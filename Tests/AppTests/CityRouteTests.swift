@testable import USkateApi
import XCTVapor

final class CityRouteTests: XCTestCase {
    func testCityRoutes() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "api/cityroutes", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testCreateCityRoute() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "api/cityroutes", beforeRequest: { req in
            let newCityRoute = CityRoute()
            newCityRoute.title = "Mexican SPb"
            newCityRoute.details = "Feel Mexico"
            newCityRoute.path = "http://yandex.ru"
            try req.content.encode(newCityRoute)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let cityRoute = try res.content.decode(CityRoute.self)
            XCTAssertEqual(cityRoute.title, "Mexican SPb")
        })
    }

    func testDeleteCityRoute() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var cityRouteID: Int?

        try app.test(.POST, "api/cityroutes", beforeRequest: { req in
            let newCityRoute = CityRoute()
            newCityRoute.title = "Mexican SPb"
            newCityRoute.details = "Feel Mexico"
            newCityRoute.path = "http://yandex.ru"
            try req.content.encode(newCityRoute)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let newCityRoute = try res.content.decode(CityRoute.self)
            cityRouteID = newCityRoute.id
        })

        XCTAssertNotNil(cityRouteID)

        guard let cityRouteID = cityRouteID else {
            return
        }

        try app.test(.DELETE, "api/cityroutes/\(cityRouteID)", afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }

    func testUpdateCityRoute() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var cityRouteID: Int?

        try app.test(.POST, "api/cityroutes", beforeRequest: { req in
            let newCityRoute = CityRoute()
            newCityRoute.title = "Mexican SPb"
            newCityRoute.details = "Feel Mexico"
            newCityRoute.path = "http://yandex.ru"
            try req.content.encode(newCityRoute)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let cityRoute = try res.content.decode(CityRoute.self)
            cityRouteID = cityRoute.id
        })

        XCTAssertNotNil(cityRouteID)

        guard let cityRouteID = cityRouteID else {
            return
        }

        try app.test(.PATCH, "api/cityroutes/\(cityRouteID)", beforeRequest: { req in
            let updatedCityRoute = CityRoute()
            updatedCityRoute.id = cityRouteID
            updatedCityRoute.title = "Spanish SPb"
            updatedCityRoute.details = "Feel Spain"
            updatedCityRoute.path = "http://vk.com"
            try req.content.encode(updatedCityRoute)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let cityRoute = try res.content.decode(CityRoute.self)
            XCTAssertEqual(cityRoute.title, "Spanish SPb")
        })
    }
}
