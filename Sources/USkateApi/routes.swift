import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        "Hello, world!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("hello", ":name") { req -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }

    try app.register(collection: UserController())
}
