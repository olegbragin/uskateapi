import Vapor
import NIOSSL

func configureSecurity(_ app: Application) throws {
    try app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
        certificateChain: [
            .certificate(.init(
                file: "/etc/letsencrypt/live/sharenergy.online/fullchain.pem",
                format: .pem
            ))
        ],
        privateKey: .privateKey(.init(file: "/etc/letsencrypt/live/sharenergy.online/privkey.pem", format: .pem))
    )
  }