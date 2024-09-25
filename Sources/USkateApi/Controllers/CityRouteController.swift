import Fluent
import Vapor

struct CityRouteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        api.group("cityroutes") { cityroutes in
            cityroutes.get(use: index)
        }
    }

    func index(req: Request) async throws -> [CityRoute] {
        try await CityRoute.query(on: req.db).all()
    }
}
