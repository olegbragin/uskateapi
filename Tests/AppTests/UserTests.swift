@testable import USkateApi
import XCTVapor

final class UserTests: XCTestCase {
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
}
