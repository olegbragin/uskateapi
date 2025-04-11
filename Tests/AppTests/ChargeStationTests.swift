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
            XCTAssertEqual(chargeStation.title, "111222")
        })
    }

    func testDeleteChargeStation() throws {
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
            let newChargeStation = try res.content.decode(ChargeStationDTO.self)
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
            let newChargeStation = ChargeStationDTO(
                latitude: 56.3, 
                longitude: 24.4, 
                title: "111222", 
                subtitle: "aergaergaergae", 
                imageSrc: "https://yandex.ru/favico", 
                chargerType: "super", 
                rating: 4, 
                isFavorite: true
            )
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
            let updatedChargeStationDTO = ChargeStationDTO(
                latitude: 56.3, 
                longitude: 24.4, 
                title: "2223334555", 
                subtitle: "aergaergaergae111111", 
                imageSrc: "https://vk.com/favico", 
                chargerType: "super3333", 
                rating: 1, 
                isFavorite: false
            )
            try req.content.encode(updatedChargeStationDTO)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let chargeStation = try res.content.decode(ChargeStation.self)
            XCTAssertEqual(chargeStation.title, "2223334555")
        })
    }
}
