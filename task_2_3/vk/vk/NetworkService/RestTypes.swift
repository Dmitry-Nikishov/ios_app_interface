//
//  RestTypes.swift
//  vk
//
//  Created by Дмитрий Никишов on 06.11.2021.
//

import Foundation

struct ToDoData {
    var userId : Int
    var id : Int
    var title : String
    var completed : Bool
}

struct PlanetData: Decodable {
    var orbitalPeriod: String

    enum CodingKeys: String, CodingKey {
        case orbitalPeriod = "orbital_period"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.orbitalPeriod = try container.decode(String.self, forKey: .orbitalPeriod)
    }
}
