import Fluent

struct CreateChargeHistoryItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("chargehistoryitem")
            .field("id", .int, .identifier(auto: true))
            .field("date", .datetime, .required)
            .field("energyDelivered", .int, .required)
            .field("duration", .int, .required)
            .field("chargingSpeed", .int, .required)
            .field("totalCost", .sql(unsafeRaw: "NUMERIC(7,2)"), .required)
            .field("chargeStationId", .int)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("chargehistoryitem").delete()
    }
}