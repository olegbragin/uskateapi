@testable import USkateApi
import XCTVapor

final class ChargeHistoryItemTests: XCTestCase {
    func testChargeHistoryItem() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "api/chargehistory", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testCreateChargeHistoryItem() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "api/chargehistory", beforeRequest: { req in
            let newChargeHistoryItem = ChargeHistoryItem()
            newChargeHistoryItem.date = Date()
            newChargeHistoryItem.energyDelivered = 1000
            newChargeHistoryItem.duration = 34
            newChargeHistoryItem.chargingSpeed = 34
            newChargeHistoryItem.totalCost = 45644.7
            newChargeHistoryItem.chargeStationId = 1
            try req.content.encode(newChargeHistoryItem)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let chargeHistoryItem = try res.content.decode(ChargeHistoryItem.self)
            XCTAssertEqual(chargeHistoryItem.energyDelivered, 1000)
        })
    }

    func testDeleteChargeHistoryItem() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargeHistoryItemID: Int?

        try app.test(.POST, "api/chargehistory", beforeRequest: { req in
            let newChargeHistoryItem = ChargeHistoryItem()
            newChargeHistoryItem.date = Date()
            newChargeHistoryItem.energyDelivered = 1000
            newChargeHistoryItem.duration = 34
            newChargeHistoryItem.chargingSpeed = 34
            newChargeHistoryItem.totalCost = 45644.7
            newChargeHistoryItem.chargeStationId = 1
            try req.content.encode(newChargeHistoryItem)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let newChargeHistoryItem = try res.content.decode(ChargeHistoryItem.self)
            chargeHistoryItemID = newChargeHistoryItem.id
        })

        XCTAssertNotNil(chargeHistoryItemID)

        guard let chargeHistoryItemID = chargeHistoryItemID else {
            return
        }

        try app.test(.DELETE, "api/chargehistory/\(chargeHistoryItemID)", afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }

    func testUpdateChargeHistoryItem() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargeHistoryItemID: Int?

        try app.test(.POST, "api/chargehistory", beforeRequest: { req in
            let newChargeHistoryItem = ChargeHistoryItem()
            newChargeHistoryItem.date = Date()
            newChargeHistoryItem.energyDelivered = 1000
            newChargeHistoryItem.duration = 34
            newChargeHistoryItem.chargingSpeed = 34
            newChargeHistoryItem.totalCost = 45644.7
            newChargeHistoryItem.chargeStationId = 1
            try req.content.encode(newChargeHistoryItem)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let chargeHistoryItem = try res.content.decode(ChargeHistoryItem.self)
            chargeHistoryItemID = chargeHistoryItem.id
        })

        XCTAssertNotNil(chargeHistoryItemID)

        guard let chargeHistoryItemID = chargeHistoryItemID else {
            return
        }

        try app.test(.PATCH, "api/chargehistory/\(chargeHistoryItemID)", beforeRequest: { req in
            let updatedChargeHistoryItem = ChargeHistoryItem()
            updatedChargeHistoryItem.id = chargeHistoryItemID
            updatedChargeHistoryItem.date = Date()
            updatedChargeHistoryItem.energyDelivered = 1000
            updatedChargeHistoryItem.duration = 34
            updatedChargeHistoryItem.chargingSpeed = 34
            updatedChargeHistoryItem.totalCost = 45644.7
            updatedChargeHistoryItem.chargeStationId = 1
            try req.content.encode(updatedChargeHistoryItem)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let chargeHistoryItem = try res.content.decode(ChargeHistoryItem.self)
            XCTAssertEqual(chargeHistoryItem.energyDelivered, 1000)
        })
    }
}
