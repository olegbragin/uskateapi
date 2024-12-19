import Fluent
import Vapor

struct ChargeStationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        api.group("chargestations") { chargeStations in
            chargeStations.get(use: index)

            chargeStations.post(use: create)

            chargeStations.group(":id") { chargeStation in
                chargeStation.patch(use: update)
                chargeStation.delete(use: delete)
            }
        }
    }

    func index(req: Request) async throws -> [ChargeStation] {
        try await ChargeStation.query(on: req.db).all()
    }

    func create(req: Request) async throws -> ChargeStation {
        let chargeStationDTO = try req.content.decode(ChargeStation.self)
        let chargeStation = ChargeStation()
        chargeStation.title = chargeStationDTO.title
        chargeStation.details = chargeStationDTO.details
        chargeStation.path = chargeStationDTO.path
        
        try await chargeStation.save(on: req.db)
        return chargeStation
    }

    func update(req: Request) async throws -> ChargeStation {
        guard let chargeStation = try await ChargeStation.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        let chargeStationDTO = try req.content.decode(ChargeStation.self)
        chargeStation.title = chargeStationDTO.title
        chargeStation.details = chargeStationDTO.details
        chargeStation.path = chargeStationDTO.path
        
        try await chargeStation.update(on: req.db)
        return chargeStation
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let chargeStation = try await ChargeStation.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await chargeStation.delete(on: req.db)
        return .noContent
    }
}
