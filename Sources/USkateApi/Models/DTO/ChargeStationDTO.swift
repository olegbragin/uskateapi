import Fluent
import Vapor

struct ChargeStationDTO: Content {
    var id: Int?
    var latitude: Double
    var longitude: Double
    var title: String?
    var subtitle: String?
    var imageSrc: String?
    var chargerType: String?
    var rating: Int?
    var isFavorite: Bool?
    var chargers: [ChargerDTO]?
}