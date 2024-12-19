import Fluent
import FluentPostgresDriver
import Vapor
import NIOSSL

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Enable TLS.
    switch app.environment {
        case .testing, .development:
            break
        default: 
            try configureSecurity(app)
    }

    app.databases.use(
        .postgres(
            configuration: SQLPostgresConfiguration(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
                username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
                password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
                database: Environment.get("DATABASE_NAME") ?? "vapor_database",
                tls: .disable
            )
        ), as: .psql
    )

    app.migrations.add(CreateUser())
    app.migrations.add(CreateCityRoute())
    app.migrations.add(CreateChargeStation())
    app.migrations.add(CreateChargeHistoryItem())

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // cors middleware should come before default error middleware using `at: .beginning`
    app.middleware.use(cors, at: .beginning)

    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
