@testable import USkateApi
import XCTVapor

final class ChargeStationTests: XCTestCase {
    func testChargeStation() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "api/chargestations", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testCreateChargeStation() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "api/chargestations", beforeRequest: { req in
            let newChargeStation = ChargeStation()
            newChargeStation.title = "Mexican SPb"
            newChargeStation.details = "Feel Mexico"
            newChargeStation.path = "http://yandex.ru"
            try req.content.encode(newChargeStation)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let chargeStation = try res.content.decode(ChargeStation.self)
            XCTAssertEqual(chargeStation.title, "Mexican SPb")
        })
    }

    func testDeleteChargeStation() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargeStationID: Int?

        try app.test(.POST, "api/chargestations", beforeRequest: { req in
            let newChargeStation = ChargeStation()
            newChargeStation.title = "Mexican SPb"
            newChargeStation.details = "Feel Mexico"
            newChargeStation.path = "http://yandex.ru"
            try req.content.encode(newChargeStation)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let newChargeStation = try res.content.decode(ChargeStation.self)
            chargeStationID = newChargeStation.id
        })

        XCTAssertNotNil(chargeStationID)

        guard let chargeStationID = chargeStationID else {
            return
        }

        try app.test(.DELETE, "api/chargestations/\(chargeStationID)", afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }

    func testUpdateChargeStation() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargeStationID: Int?

        try app.test(.POST, "api/chargestations", beforeRequest: { req in
            let newChargeStation = ChargeStation()
            newChargeStation.title = "Mexican SPb"
            newChargeStation.details = "Feel Mexico"
            newChargeStation.path = "http://yandex.ru"
            try req.content.encode(newChargeStation)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let chargeStation = try res.content.decode(ChargeStation.self)
            chargeStationID = chargeStation.id
        })

        XCTAssertNotNil(chargeStationID)

        guard let chargeStationID = chargeStationID else {
            return
        }

        try app.test(.PATCH, "api/chargestations/\(chargeStationID)", beforeRequest: { req in
            let updatedChargeStation = ChargeStation()
            updatedChargeStation.id = chargeStationID
            updatedChargeStation.title = "Spanish SPb"
            updatedChargeStation.details = "Feel Spain"
            updatedChargeStation.path = "http://vk.com"
            try req.content.encode(updatedChargeStation)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let chargeStation = try res.content.decode(ChargeStation.self)
            XCTAssertEqual(chargeStation.title, "Spanish SPb")
        })
    }
}
