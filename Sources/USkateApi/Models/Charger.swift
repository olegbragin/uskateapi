import Fluent
import Vapor

final class Charger: Model, Content {
    static let schema = "charger"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "plug")
    var plug: Int

    @Field(key: "state")
    var state: Int

    @Field(key: "price")
    var price: String

    @OptionalParent(key: "chargestation_id")
    var chargeStation: ChargeStation?

    init() { }

    init(id: Int? = nil, plug: Int, state: Int, price: String) {
        self.id = id
        self.plug = plug
        self.state = state
        self.price = price
    }
}
