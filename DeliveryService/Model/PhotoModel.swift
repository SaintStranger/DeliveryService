//
//  PhotoModel.swift
//  DeliveryService
//
//  Created by test on 02.05.2022.
//

import Foundation
import Firebase

struct SearchResult: Decodable {
    let results: [PhotoModel]?
}

//extension DatabaseQuery {
//
//    func decoded<Type:Decodable>() throws -> Type {
//
//        let recievedData = try JSONSerialization.data(withJSONObject: ref, options: [])
//        let object = try JSONDecoder().decode(Type.self, from: recievedData)
//        return object
//    }
//}


struct PhotoModel: Decodable {
    var id: String
    var date: String
    var photos: Urls
    var likes: Int
    var user: User
    var location: Location?

    enum CodingKeys: String, CodingKey {
        case id
        case date = "created_at"
        case photos = "urls"
        case likes
        case location
        case user
    }
    

    func toDatabase() -> [String: Any] {
        return [
            "id": id,
            "user": [
                "name": user.name,
            ],
            "date": date,
            "likes": likes,
            "location": [
                "location_title": location?.title ?? "",
                "location_name": location?.name ?? "",
                "location_country": location?.country ?? ""
            ],
            "photos": [
                "bigPhoto": photos.regular,
                "smallPhoto": photos.small
            ]
        ]
    }
    
}

// MARK: Урлы
struct Urls: Decodable {
    var regular: String
    var small: String

    enum CodingKeys: String, CodingKey {
        case regular
        case small = "thumb"
    }
    
}

// MARK: Юзер
struct User: Decodable {
    var name: String
}

// MARK: Локация
struct Location: Decodable {
    var title: String?
    var name: String?
    var country: String?
//    let position: Position?
}

// MARK: Широта и долгота
//struct Position: Decodable {
//    let latitude: Float?
//    let longitude: Float?
//}
