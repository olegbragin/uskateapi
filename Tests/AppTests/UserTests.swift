@testable import USkateApi
import XCTVapor

final class UserTests: XCTestCase {
    func testUsers() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "api/users", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testCreateUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var userID: Int?

        try app.test(.POST, "api/users", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
            let newUser = UserDTO(
                username: "key",
                firstname: "Kate", 
                lastname: "Bragina", 
                isActive: false
            )
            try req.content.encode(newUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(UserDTO.self)
            userID = user.id
            XCTAssertEqual(user.firstname, "Kate")
        })

        guard let userID = userID else {
            return
        }

        try app.test(.DELETE, "api/users/\(userID)", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }

    func testUserInfo() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var userID: Int?

        try app.test(.POST, "api/users", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
            let newUser = UserDTO(
                username: "key",
                firstname: "Kate", 
                lastname: "Bragina", 
                isActive: false
            )
            try req.content.encode(newUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(UserDTO.self)
            userID = user.id
            XCTAssertEqual(user.firstname, "Kate")
        })

        guard let userID = userID else {
            return
        }

        try app.test(.GET, "api/users/\(userID)", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(UserDTO.self)
            XCTAssertNotNil(user.id)
        })

        try app.test(.DELETE, "api/users/\(userID)", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }

    func testDeleteUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var userID: Int?

        try app.test(.POST, "api/users", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
            let newUser = UserDTO(
                username: "keyf",
                firstname: "Kate", 
                lastname: "Bragina", 
                isActive: false
            )
            try req.content.encode(newUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(UserDTO.self)
            userID = user.id
        })

        XCTAssertNotNil(userID)

        guard let userID = userID else {
            return
        }

        try app.test(.DELETE, "api/users/\(userID)", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }

    func testUpdateUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var userID: Int?

        try app.test(.POST, "api/users", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
            let newUser = UserDTO(
                username: "keyf",
                firstname: "Kate", 
                lastname: "Bragina", 
                isActive: false
            )
            try req.content.encode(newUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(UserDTO.self)
            userID = user.id
        })

        XCTAssertNotNil(userID)

        guard let userID = userID else {
            return
        }

        try app.test(.PATCH, "api/users/\(userID)", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: "vapor_admin")
            let updatedUser = UserDTO(
                username: "key",
                firstname: "Oleg", 
                lastname: "Bragin", 
                isActive: true
            )
            try req.content.encode(updatedUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let user = try res.content.decode(UserDTO.self)
            XCTAssertEqual(user.isActive, true)
            XCTAssertEqual(user.firstname, "Oleg")
        })
    }
}
