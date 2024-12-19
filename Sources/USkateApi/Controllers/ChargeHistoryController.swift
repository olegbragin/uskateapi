
import Fluent
import Vapor

struct ChargeHistoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")

        api.group("chargehistory") { chargeHistory in
            chargeHistory.get(use: index)

            chargeHistory.post(use: create)

            chargeHistory.group(":id") { chargeHistoryItem in
                chargeHistoryItem.patch(use: update)
                chargeHistoryItem.delete(use: delete)
            }
        }
    }

    func index(req: Request) async throws -> [ChargeHistoryItem] {
        try await ChargeHistoryItem.query(on: req.db).all()
    }

    func create(req: Request) async throws -> ChargeHistoryItem {
        let chargeHistoryItemDTO = try req.content.decode(ChargeHistoryItem.self)
        let chargeHistoryItem = ChargeHistoryItem()
        chargeHistoryItem.title = chargeHistoryItemDTO.title
        chargeHistoryItem.details = chargeHistoryItemDTO.details
        chargeHistoryItem.path = chargeHistoryItemDTO.path
        
        try await chargeHistoryItem.save(on: req.db)
        return chargeHistoryItem
    }

    func update(req: Request) async throws -> ChargeHistoryItem {
        guard let chargeHistoryItem = try await ChargeHistoryItem.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        let chargeHistoryItemDTO = try req.content.decode(ChargeHistoryItem.self)
        chargeHistoryItem.title = chargeHistoryItemDTO.title
        chargeHistoryItem.details = chargeHistoryItemDTO.details
        chargeHistoryItem.path = chargeHistoryItemDTO.path
        
        try await chargeHistoryItem.update(on: req.db)
        return chargeHistoryItem
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let chargeHistoryItem = try await ChargeHistoryItem.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await chargeHistoryItem.delete(on: req.db)
        return .noContent
    }
}
