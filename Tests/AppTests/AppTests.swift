@testable import USkateApi
import XCTVapor

final class AppTests: XCTestCase {
    func testUsers() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "api/users", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testCreateUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "api/users", beforeRequest: { req in
            let newUser = User()
            newUser.firstname = "Kate"
            newUser.lastname = "Bragina"
            newUser.isActive = false
            try req.content.encode(newUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(User.self)
            XCTAssertEqual(user.firstname, "Kate")
        })
    }

    func testDeleteUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var userID: Int?

        try app.test(.POST, "api/users", beforeRequest: { req in
            let newUser = User()
            newUser.firstname = "Kate"
            newUser.lastname = "Bragina"
            newUser.isActive = false
            try req.content.encode(newUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(User.self)
            userID = user.id
        })

        XCTAssertNotNil(userID)

        guard let userID = userID else {
            return
        }

        try app.test(.DELETE, "api/users/\(userID)", afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }

    func testUpdateUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var userID: Int?

        try app.test(.POST, "api/users", beforeRequest: { req in
            let newUser = User()
            newUser.firstname = "Kate"
            newUser.lastname = "Bragina"
            newUser.isActive = false
            try req.content.encode(newUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(User.self)
            userID = user.id
        })

        XCTAssertNotNil(userID)

        guard let userID = userID else {
            return
        }

        try app.test(.PATCH, "api/users/\(userID)", beforeRequest: { req in
            let updatedUser = User()
            updatedUser.id = userID
            updatedUser.firstname = "Oleg"
            updatedUser.lastname = "Bragin"
            updatedUser.isActive = true
            try req.content.encode(updatedUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let user = try res.content.decode(User.self)
            XCTAssertEqual(user.isActive, true)
            XCTAssertEqual(user.firstname, "Oleg")
        })
    }

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

    func testDeletenewCityRoute() throws {
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
