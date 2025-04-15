import Fluent

struct UpdateChargeStation: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("chargestation")
          .deleteField("chargerType")
          .update()
        
        try await database.schema("chargestation")
          .field("phone", .string, .required)
          .field("workTime", .string, .required)
          .field("parking", .string, .required)
          .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("chargestation").delete()
    }
}