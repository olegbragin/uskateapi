import Fluent

struct CreateChargeHistoryItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("chargehistoryitem")
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("details", .string, .required)
            .field("path", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("chargehistoryitem").delete()
    }
}
