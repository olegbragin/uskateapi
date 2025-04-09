import Fluent
import Vapor

struct ChargerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        api.group("chargers") { chargers in
            chargers.get(use: index)

            chargers.post(use: create)

            chargers.group(":id") { charger in
                charger.patch(use: update)
                charger.delete(use: delete)
            }
        }
    }

    func index(req: Request) async throws -> [Charger] {
        try await Charger.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Charger {
        let chargerDTO = try req.content.decode(Charger.self)
        let charger = Charger()
        charger.plug = chargerDTO.plug
        charger.state = chargerDTO.state
        charger.price = chargerDTO.price
        
        try await charger.save(on: req.db)
        return charger
    }

    func update(req: Request) async throws -> Charger {
        guard let charger = try await Charger.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        let chargerDTO = try req.content.decode(Charger.self)
        charger.plug = chargerDTO.plug
        charger.state = chargerDTO.state
        charger.price = chargerDTO.price
        
        try await charger.update(on: req.db)
        return charger
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let charger = try await Charger.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await charger.delete(on: req.db)
        return .noContent
    }
}
