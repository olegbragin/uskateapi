import Fluent
import Vapor

struct CityRouteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        api.group("cityroutes") { cityRoutes in
            cityRoutes.get(use: index)

            cityRoutes.post(use: create)

            cityRoutes.group(":id") { cityRoute in
                cityRoute.patch(use: update)
                cityRoute.delete(use: delete)
            }
        }
    }

    func index(req: Request) async throws -> [CityRoute] {
        try await CityRoute.query(on: req.db).all()
    }

    func create(req: Request) async throws -> CityRoute {
        let cityRouteDTO = try req.content.decode(CityRoute.self)
        let cityRoute = CityRoute()
        cityRoute.title = cityRouteDTO.title
        cityRoute.details = cityRouteDTO.details
        cityRoute.path = cityRouteDTO.path
        
        try await cityRoute.save(on: req.db)
        return cityRoute
    }

    func update(req: Request) async throws -> CityRoute {
        guard let cityRoute = try await CityRoute.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        let cityRouteDTO = try req.content.decode(CityRoute.self)
        cityRoute.title = cityRouteDTO.title
        cityRoute.details = cityRouteDTO.details
        cityRoute.path = cityRouteDTO.path
        
        try await cityRoute.update(on: req.db)
        return cityRoute
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let cityRoute = try await CityRoute.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await cityRoute.delete(on: req.db)
        return .noContent
    }
}
