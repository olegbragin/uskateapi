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
            let newCharger = ChargerDTO(
                plug: 1, 
                state: 0, 
                price: "100"
            )
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let charger = try res.content.decode(ChargerDTO.self)
            XCTAssertEqual(charger.price, "100")
        })
    }

    func testDeleteUnattachedCharger() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargerID: Int?

        try app.test(.POST, "api/chargers", beforeRequest: { req in
            let newCharger = ChargerDTO(
                plug: 1, 
                state: 0, 
                price: "100"
            )
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let newCharger = try res.content.decode(ChargerDTO.self)
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
            let newCharger = ChargerDTO(
                plug: 1, 
                state: 0, 
                price: "100"
            )
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let charger = try res.content.decode(ChargerDTO.self)
            chargerID = charger.id
        })

        XCTAssertNotNil(chargerID)

        guard let chargerID = chargerID else {
            return
        }

        try app.test(.PATCH, "api/chargers/\(chargerID)", beforeRequest: { req in
        let newCharger = ChargerDTO(
                plug: 2, 
                state: 1, 
                price: "200"
            )
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let charger = try res.content.decode(ChargerDTO.self)
            XCTAssertEqual(charger.price, "200")
        })
    }

    func testCreateAttachedCharger() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargeStationID: Int?

        try app.test(.POST, "api/chargestations", beforeRequest: { req in
            let newChargeStation = ChargeStationDTO(
                latitude: 56.3, 
                longitude: 24.4, 
                title: "111222", 
                subtitle: "aergaergaergae", 
                imageSrc: "https://yandex.ru/favico", 
                chargerType: "super", 
                rating: 4, 
                isFavorite: true, 
                chargers: [ChargerDTO(
                    plug: 1, 
                    state: 0, 
                    price: "100"
                )]
            )
            try req.content.encode(newChargeStation)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let chargeStation = try res.content.decode(ChargeStationDTO.self)
            chargeStationID = chargeStation.id
        })

        guard let chargeStationID = chargeStationID else {
            return
        }

        var chargerID: Int?

        try app.test(.POST, "api/chargers", beforeRequest: { req in
            let newCharger = ChargerDTO(
                plug: 1, 
                state: 0, 
                price: "100", 
                chargeStation: chargeStationID
            )
            try req.content.encode(newCharger)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let newCharger = try res.content.decode(ChargerDTO.self)
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
}
