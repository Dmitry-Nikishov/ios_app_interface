//
//  StorageService.swift
//  vk
//
//  Created by Дмитрий Никишов on 01.09.2021.
//

import Foundation

public struct Data {
    public static let dataToDisplay = [
        Post(author: "vedmak.official",
             description: "Новые кадры со съемок фильма \"Ведьмак\"",
             image: "vedmak",
             likes: 240,
             views: 312),
        
        Post(author: "Нетология. Меняем карьеру через образование",
             description: """
                От 'Hello World' до первого сложного iOS-приложения - всего за один курс.
            Если чувствуете в себе силу для покорения топов AppStore - пора начинать действовать!
            Профессия \"IOS-разработчик\" - тот самый путь, по которому стоит пройти до самого конца.
            Вы научитесь создавать приложения на яхыке Swuft с нуля : от начинки до интерфейса. Чтобы закрепить знания на практике, каждый студент подготовит дипломную работу - VK-like приложения
            с возможностью публиковать фотографии, использовать фильтры, ставить лайки и подписываться на других пользователей.
            """,
             image: "netology_media",
             likes: 766,
             views: 893),
        
        Post(author: "кинопоиск hd",
             description: "Фильм про стритрейсеров",
             image: "fast_and_furious",
             likes: 1000,
             views: 1000),
        
        Post(author: "афиша",
             description: "По роману Фрэнка Геберта",
             image: "dune",
             likes: 10000,
             views: 10000)
    ]
}
