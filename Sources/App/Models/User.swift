import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "firstname")
    var firstname: String

    @Field(key: "lastname")
    var lastname: String

    init() { }

    init(id: UUID? = nil, firstname: String, lastname: String) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
    }
}
