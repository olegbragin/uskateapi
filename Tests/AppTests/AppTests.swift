@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }

    func testUsers() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "users", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testCreateUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "users", beforeRequest: { req in
            let newUser = User()
            newUser.firstname = "Kate"
            newUser.lastname = "Bragina"
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

        var userID: UUID?

        try app.test(.POST, "users", beforeRequest: { req in
            let newUser = User()
            newUser.firstname = "Kate"
            newUser.lastname = "Bragina"
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

        try app.test(.DELETE, "users/\(userID)", afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }
}
