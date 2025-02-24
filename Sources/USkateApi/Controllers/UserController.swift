import Fluent
import Vapor
import VaporToOpenAPI

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        api.group("users") { users in
            users
                .get(use: index)
                .openAPI(
					summary: "Get all users list",
					description: "This can only be done by the logged in user.",
					body: .type(User.self),
					contentType: .application(.json),
					response: .type(User.self),
					responseContentType: .application(.json)
				)
            users.post(use: create)

            users.group(":id") { user in
                user.patch(use: update)
                user.delete(use: delete)
            }
        }
    }

    func index(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }

    func create(req: Request) async throws -> User {
        let userDTO = try req.content.decode(User.self)
        let user = User()
        user.firstname = userDTO.firstname
        user.lastname = userDTO.lastname
        user.isActive = userDTO.isActive
        
        try await user.save(on: req.db)
        return user
    }

    func update(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        let userDTO = try req.content.decode(User.self)
        user.firstname = userDTO.firstname
        user.lastname = userDTO.lastname
        user.isActive = userDTO.isActive
        
        try await user.update(on: req.db)
        return user
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await user.delete(on: req.db)
        return .noContent
    }
}
