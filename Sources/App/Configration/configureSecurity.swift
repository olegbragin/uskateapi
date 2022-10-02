import Vapor
import NIOSSL

func configureSecurity(_ app: Application) throws {
    try app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
        certificateChain: [
            .certificate(.init(
                file: "cert.pem",
                format: .pem
            ))
        ],
        privateKey: .file("key.pem")
    )
  }