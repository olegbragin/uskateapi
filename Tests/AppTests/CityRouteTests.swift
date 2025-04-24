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
            let newCityRoute = CityRouteDTO(
                title: "Mexican SPb", 
                details: "Feel Mexico", 
                path: "http://yandex.ru"
            )
            try req.content.encode(newCityRoute)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let cityRoute = try res.content.decode(CityRouteDTO.self)
            XCTAssertEqual(cityRoute.title, "Mexican SPb")
        })
    }

    func testDeleteCityRoute() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var cityRouteID: Int?

        try app.test(.POST, "api/cityroutes", beforeRequest: { req in
            let newCityRoute = CityRouteDTO(
                title: "Mexican SPb", 
                details: "Feel Mexico", 
                path: "http://yandex.ru"
            )
            try req.content.encode(newCityRoute)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let newCityRoute = try res.content.decode(CityRouteDTO.self)
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
            let newCityRoute = CityRouteDTO(
                title: "Mexican SPb", 
                details: "Feel Mexico", 
                path: "http://yandex.ru"
            )
            try req.content.encode(newCityRoute)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let cityRoute = try res.content.decode(CityRouteDTO.self)
            cityRouteID = cityRoute.id
        })

        XCTAssertNotNil(cityRouteID)

        guard let cityRouteID = cityRouteID else {
            return
        }

        try app.test(.PATCH, "api/cityroutes/\(cityRouteID)", beforeRequest: { req in
            let updatedCityRoute = CityRouteDTO(
                id: cityRouteID, 
                title: "Spanish SPb", 
                details: "Feel Spain", 
                path: "http://vk.com"
            )
            try req.content.encode(updatedCityRoute)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let cityRoute = try res.content.decode(CityRoute.self)
            XCTAssertEqual(cityRoute.title, "Spanish SPb")
        })
    }
}
