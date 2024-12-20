import Fluent
import Vapor

final class ChargeStation: Model, Content {
    static let schema = "chargestation"
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "latitude")
    var latitude: Double

    @Field(key: "longitude")
    var longitude: Double

    @Field(key: "title")
    var title: String?

    @Field(key: "subtitle")
    var subtitle: String?

    @Field(key: "imageSrc")
    var imageSrc: String?

    @Field(key: "chargerType")
    var chargerType: String?

    @ID(custom: "rating")
    var rating: Int?

    @Field(key: "isFavorite")
    var isFavorite: Bool?

    init() { }

    init(
        id: Int,
        latitude: Double,
        longitude: Double,
        title: String? = nil,
        subtitle: String? = nil,
        imageSrc: String? = nil,
        chargerType: String? = nil,
        rating: Int? = nil,
        isFavorite: Bool? = nil
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
        self.imageSrc = imageSrc
        self.chargerType = chargerType
        self.rating = rating
        self.isFavorite = isFavorite
    }
}