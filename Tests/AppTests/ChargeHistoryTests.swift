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
            newChargeHistoryItem.title = "Mexican SPb"
            newChargeHistoryItem.details = "Feel Mexico"
            newChargeHistoryItem.path = "http://yandex.ru"
            try req.content.encode(newChargeHistoryItem)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let chargeHistoryItem = try res.content.decode(ChargeHistoryItem.self)
            XCTAssertEqual(chargeHistoryItem.title, "Mexican SPb")
        })
    }

    func testDeleteChargeHistoryItem() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        var chargeHistoryItemID: Int?

        try app.test(.POST, "api/chargehistory", beforeRequest: { req in
            let newChargeHistoryItem = ChargeHistoryItem()
            newChargeHistoryItem.title = "Mexican SPb"
            newChargeHistoryItem.details = "Feel Mexico"
            newChargeHistoryItem.path = "http://yandex.ru"
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
            newChargeHistoryItem.title = "Mexican SPb"
            newChargeHistoryItem.details = "Feel Mexico"
            newChargeHistoryItem.path = "http://yandex.ru"
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
            updatedChargeHistoryItem.title = "Spanish SPb"
            updatedChargeHistoryItem.details = "Feel Spain"
            updatedChargeHistoryItem.path = "http://vk.com"
            try req.content.encode(updatedChargeHistoryItem)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let chargeHistoryItem = try res.content.decode(ChargeHistoryItem.self)
            XCTAssertEqual(chargeHistoryItem.title, "Spanish SPb")
        })
    }
}
