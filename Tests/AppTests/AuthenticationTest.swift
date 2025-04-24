@testable import USkateApi
import XCTVapor

final class AuthenticationTests: XCTestCase {
    func testSignUp() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try signUpUser(app: app) { userID, token in
          try app.test(.DELETE, "api/users/\(userID)", beforeRequest: { req in
              req.headers.bearerAuthorization = .init(token: "vapor_admin")
          }, afterResponse: { res in
              XCTAssertEqual(res.status, .noContent)
          })
        }
    }

    func testSignOut() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try signUpUser(app: app) { userID, token in
          try app.test(.DELETE, "api/users/signout", beforeRequest: { req in
              req.headers.bearerAuthorization = .init(token: token)
          }, afterResponse: { res in
              XCTAssertEqual(res.status, .noContent)
          })

          try app.test(.DELETE, "api/users/\(userID)", beforeRequest: { req in
              req.headers.bearerAuthorization = .init(token: "vapor_admin")
          }, afterResponse: { res in
              XCTAssertEqual(res.status, .noContent)
          })
        }
    }

    func testSignIn() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try signUpUser(app: app) { userID, token in
          try app.test(.DELETE, "api/users/signout", beforeRequest: { req in
              req.headers.bearerAuthorization = .init(token: token)
          }, afterResponse: { res in
              XCTAssertEqual(res.status, .noContent)
          })

          var oneTimeCode: String?
          var hash: String?

          try app.test(.POST, "api/users/signin", beforeRequest: { req in
              let newUser = UserDTO.SignIn(
                  username: "+79211234567",
                  usernameType: .phone
              )
              try req.content.encode(newUser)
          }, afterResponse: { res in
              XCTAssertEqual(res.status, .ok)
              let confirm = try res.content.decode(UserDTO.RequestConfirm.self)
              oneTimeCode = confirm.onetimecode
              hash = confirm.hash
          })

          XCTAssertNotNil(hash)
          XCTAssertNotNil(oneTimeCode)

          guard let oneTimeCode = oneTimeCode, let hash = hash else {
              return
          }

          var token: String?

          try app.test(.POST, "api/users/confirm", beforeRequest: { req in
              let confirm = UserDTO.RequestConfirm(
                  hash: hash, 
                  onetimecode: oneTimeCode, 
                  status: .signIn
              )
              try req.content.encode(confirm)
          }, afterResponse: { res in
              XCTAssertEqual(res.status, .ok)
              let userToken = try res.content.decode(UserTokenDTO.self)
              token = userToken.value
          })

          XCTAssertNotNil(token)

          guard let token = token else {
              return
          }

          var userID: Int?

          try app.test(.GET, "api/users/me", beforeRequest: { req in
              req.headers.bearerAuthorization = .init(token: token)
          }, afterResponse: { res in
              XCTAssertEqual(res.status, .ok)
              let user = try res.content.decode(UserDTO.self)
              userID = user.id
          })

          guard let userID = userID else {
              return
          }

          
        }
    }

    func testUsers_Unauthorized() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "api/users", afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }

    private func signUpUser(app: Application, afterSignUp: (Int, String) throws -> Void) throws {
        var oneTimeCode: String?
        var hash: String?

        try app.test(.POST, "api/users/signup", beforeRequest: { req in
            let newUser = UserDTO.SignUp(
                username: "+79211234567",
                usernameType: UserNameType.phone,
                firstname: "Kate", 
                lastname: "Bragina",
                email: "egergagr@aergerge.com"
            )
            try req.content.encode(newUser)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let confirm = try res.content.decode(UserDTO.RequestConfirm.self)
            oneTimeCode = confirm.onetimecode
            hash = confirm.hash
        })

        XCTAssertNotNil(hash)
        XCTAssertNotNil(oneTimeCode)

        guard let oneTimeCode = oneTimeCode, let hash = hash else {
            return
        }

        var token: String?

        try app.test(.POST, "api/users/confirm", beforeRequest: { req in
            let confirm = UserDTO.RequestConfirm(
                hash: hash, 
                onetimecode: oneTimeCode, 
                status: .signUp
            )
            try req.content.encode(confirm)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let userToken = try res.content.decode(UserTokenDTO.self)
            token = userToken.value
        })

        XCTAssertNotNil(token)

        guard let token = token else {
            return
        }

        var userID: Int?

        try app.test(.GET, "api/users/me", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: token)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try res.content.decode(UserDTO.self)
            userID = user.id
        })

        guard let userID = userID else {
            return
        }

        try afterSignUp(userID, token)
    }
}
