import Vapor
import NIOSSL

func configureSecurity(_ app: Application) throws {
    try app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
        certificateChain: [
            .certificate(.init(
                file: "/etc/ssl/certs/ssl-cert-snakeoil.pem",
                format: .pem
            ))
        ],
        privateKey: .privateKey(.init(file: "/etc/ssl/private/ssl-cert-snakeoil.key", format: .pem))
    )
  }