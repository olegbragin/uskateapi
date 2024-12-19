import Fluent

struct CreateChargeStation: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("chargestation")
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("details", .string, .required)
            .field("path", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("chargestation").delete()
    }
}
