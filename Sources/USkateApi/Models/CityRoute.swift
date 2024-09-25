import Fluent
import Vapor

final class CityRoute: Model, Content {
    static let schema = "cityroute"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "title")
    var title: String

    @Field(key: "details")
    var details: String

    @Field(key: "path")
    var path: String

    init() { }

    init(id: Int? = nil, title: String, details: String, path: String) {
        self.id = id
        self.title = title
        self.details = details
        self.path = path
    }
}
