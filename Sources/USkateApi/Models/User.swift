import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "user"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "firstname")
    var firstname: String

    @Field(key: "lastname")
    var lastname: String

    @Boolean(key: "isActive")
    var isActive: Bool

    init() { }

    init(id: Int? = nil, firstname: String, lastname: String, isActive: Bool = false) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.isActive = isActive
    }
}
