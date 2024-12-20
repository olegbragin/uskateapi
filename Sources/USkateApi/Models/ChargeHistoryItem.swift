import Fluent
import Vapor

final class ChargeHistoryItem: Model, Content {
    static let schema = "chargehistoryitem"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "date")
    var date: Date

    @Field(key: "energyDelivered")
    var energyDelivered: Int

    @Field(key: "duration")
    var duration: Int

    @Field(key: "chargingSpeed")
    var chargingSpeed: Int

    @Field(key: "totalCost")
    var totalCost: Decimal

    @Field(key: "chargeStationId")
    var chargeStationId: Int?

    init() { }

    init(
        id: Int? = nil, 
        date: Date, 
        energyDelivered: Int,
        duration: Int,
        chargingSpeed: Int,
        totalCost: Decimal,
        chargeStationId: Int?
    ) {
        self.id = id
        self.date = date
        self.energyDelivered = energyDelivered
        self.duration = duration
        self.chargingSpeed = chargingSpeed
        self.totalCost = totalCost
        self.chargeStationId = chargeStationId
    }
}