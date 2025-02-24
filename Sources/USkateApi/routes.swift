import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: OpenApiController())
    try app.register(collection: UserController())
    try app.register(collection: CityRouteController())
    try app.register(collection: ChargeStationController())
    try app.register(collection: ChargeHistoryController())
}
