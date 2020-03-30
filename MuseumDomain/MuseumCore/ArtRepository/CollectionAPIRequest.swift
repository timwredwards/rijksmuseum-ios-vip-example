import Foundation
import Utils

public struct CollectionAPIRequest: APIRequest {

    public typealias ResponseJSONType = CollectionJSON

    public var pathExtension = "/collection"

    public let queryItems: [URLQueryItem] = [
        .init(name: "ps", value: "100"),
        .init(name: "imgonly", value: "true"),
        .init(name: "s", value: "relevance"),
    ]
}

public struct CollectionJSON: Decodable {
    private enum CodingKeys: String, CodingKey {
        case artArray = "artObjects"
    }

    public let artJSONs: [ArtJSON]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artJSONs = try container.decode([ArtJSON].self, forKey: .artArray)
    }
}

public struct ArtJSON: Art, Decodable {
    enum CodingKeys: String, CodingKey {
        case artArray = "artObjects"
        case id = "objectNumber"
        case title
        case artist = "principalOrFirstMaker"
        case imageDict = "webImage"
        case imageURL = "url"
    }

    public var id: String
    public var title: String
    public var artist: String
    public var imageURL: URL

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        artist = try container.decode(String.self, forKey: .artist)
        let webImage = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageDict)
        imageURL = try webImage.decode(URL.self, forKey: .imageURL)
    }
}