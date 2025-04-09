@testable import USkateApi
import XCTVapor

final class ChargerTests: XCTestCase {
    func testChargers() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "api/chargers", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testCreateUnattachedCharger() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "api/chargers", beforeRequest: { req in
            let newCharger = Charger()
            newCharger.plug = 1
            newCharger.state = 0
            newCharger.price = "100"
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let charger = try res.content.decode(Charger.self)
            XCTAssertEqual(charger.price, "100")
        })
    }

    func testDeleteUnattachedCharger() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargerID: Int?

        try app.test(.POST, "api/chargers", beforeRequest: { req in
            let newCharger = Charger()
            newCharger.plug = 1
            newCharger.state = 0
            newCharger.price = "100"
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let newCharger = try res.content.decode(Charger.self)
            chargerID = newCharger.id
        })

        XCTAssertNotNil(chargerID)

        guard let chargerID = chargerID else {
            return
        }

        try app.test(.DELETE, "api/chargers/\(chargerID)", afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }

    func testUpdateUnattachedCharger() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargerID: Int?

        try app.test(.POST, "api/chargers", beforeRequest: { req in
            let newCharger = Charger()
            newCharger.plug = 1
            newCharger.state = 0
            newCharger.price = "100"
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let charger = try res.content.decode(Charger.self)
            chargerID = charger.id
        })

        XCTAssertNotNil(chargerID)

        guard let chargerID = chargerID else {
            return
        }

        try app.test(.PATCH, "api/chargers/\(chargerID)", beforeRequest: { req in
            let newCharger = Charger()
            newCharger.plug = 2
            newCharger.state = 1
            newCharger.price = "200"
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let charger = try res.content.decode(Charger.self)
            XCTAssertEqual(charger.price, "200")
        })
    }
}
