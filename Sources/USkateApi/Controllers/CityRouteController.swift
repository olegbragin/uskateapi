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

    func index(req: Request) async throws -> [CityRouteDTO] {
        try await CityRoute.query(on: req.db).all().map {
            CityRouteDTO(
                id: $0.id, 
                title: $0.title, 
                details: $0.details, 
                path: $0.path
            )
        }
    }

    func create(req: Request) async throws -> CityRouteDTO {
        var cityRouteDTO = try req.content.decode(CityRouteDTO.self)
        let cityRoute = CityRoute(
            title: cityRouteDTO.title, 
            details: cityRouteDTO.details, 
            path: cityRouteDTO.path
        )        
        try await cityRoute.save(on: req.db)
        cityRouteDTO.id = cityRoute.id
        return cityRouteDTO
    }

    func update(req: Request) async throws -> CityRouteDTO {
        guard let cityRoute = try await CityRoute.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        let cityRouteDTO = try req.content.decode(CityRouteDTO.self)
        cityRoute.title = cityRouteDTO.title
        cityRoute.details = cityRouteDTO.details
        cityRoute.path = cityRouteDTO.path
        
        try await cityRoute.update(on: req.db)
        return cityRouteDTO
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let cityRoute = try await CityRoute.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await cityRoute.delete(on: req.db)
        return .noContent
    }
}
