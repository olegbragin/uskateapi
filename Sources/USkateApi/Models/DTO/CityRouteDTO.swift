import Fluent
import Vapor

struct CityRouteDTO: Content {
    var id: Int?
    var title: String
    var details: String
    var path: String
}