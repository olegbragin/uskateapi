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
            newChargeStation.latitude = 56.3
            newChargeStation.longitude = 24.4
            newChargeStation.title = "111222"
            newChargeStation.subtitle = "aergaergaergae"
            newChargeStation.imageSrc = "https://yandex.ru/favico"
            newChargeStation.chargerType = "super"
            newChargeStation.rating = 4
            newChargeStation.isFavorite = true
            try req.content.encode(newChargeStation)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let chargeStation = try res.content.decode(ChargeStation.self)
            XCTAssertEqual(chargeStation.title, "111222")
        })
    }

    func testDeleteChargeStation() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargeStationID: Int?

        try app.test(.POST, "api/chargestations", beforeRequest: { req in
            let newChargeStation = ChargeStation()
            newChargeStation.latitude = 56.3
            newChargeStation.longitude = 24.4
            newChargeStation.title = "111222"
            newChargeStation.subtitle = "aergaergaergae"
            newChargeStation.imageSrc = "https://yandex.ru/favico"
            newChargeStation.chargerType = "super"
            newChargeStation.rating = 4
            newChargeStation.isFavorite = true
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
            newChargeStation.latitude = 56.3
            newChargeStation.longitude = 24.4
            newChargeStation.title = "111222"
            newChargeStation.subtitle = "aergaergaergae"
            newChargeStation.imageSrc = "https://yandex.ru/favico"
            newChargeStation.chargerType = "super"
            newChargeStation.rating = 4
            newChargeStation.isFavorite = true
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
            updatedChargeStation.latitude = 56.3
            updatedChargeStation.longitude = 24.4
            updatedChargeStation.title = "2223334555"
            updatedChargeStation.subtitle = "aergaergaergae111111"
            updatedChargeStation.imageSrc = "https://vk.com/favico"
            updatedChargeStation.chargerType = "super3333"
            updatedChargeStation.rating = 1
            updatedChargeStation.isFavorite = false
            try req.content.encode(updatedChargeStation)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let chargeStation = try res.content.decode(ChargeStation.self)
            XCTAssertEqual(chargeStation.title, "2223334555")
        })
    }
}
