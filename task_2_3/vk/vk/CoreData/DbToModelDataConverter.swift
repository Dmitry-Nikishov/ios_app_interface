//
//  DbToModelDataConverter.swift
//  vk
//
//  Created by Дмитрий Никишов on 04.12.2021.
//

import Foundation
import StorageService

class DbToFromDataConverter {
    static func toModel(post : PostDb) -> Post {
        return Post(author : post.author ?? "",
                    description : post.content ?? "",
                    image : post.image ?? "",
                    likes : Int(post.likes),
                    views : Int(post.views)
                    )
    }
}
