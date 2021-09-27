//
//  AsyncImageProcessor.swift
//  vk
//
//  Created by Дмитрий Никишов on 28.09.2021.
//

import Foundation
import UIKit
import StorageService
import iOSIntPackage

class AsyncImageProcessor : Thread {
    private let posts : [Post]
    private let userHandler : ImageProcessorHandler
    private var asyncResult : [UIImage?]
    
    init(posts : [Post], completion: @escaping ImageProcessorHandler) {
        self.posts = posts
        userHandler = completion
        asyncResult = Array(repeating: nil, count: posts.count)
        super.init()
    }
    
    override func main() {
        var imagesToProcess : [UIImage] = []
        for postItem in self.posts {
            if let image = UIImage(named: postItem.image) {
                imagesToProcess.append(image)
            }
        }
        
        ImageProcessor().processImagesOnThread(sourceImages: imagesToProcess,
                                               filter: ColorFilter.allCases.randomElement()!,
                                               qos : .default)
        {
            (resultCGImages : [CGImage?]) in

            for (index, indexImage) in resultCGImages.enumerated() {
                if let cgImage = indexImage {
                    self.asyncResult[index] = UIImage(cgImage: cgImage)
                }
            }
            
            self.userHandler(self.asyncResult)
        }
    }
}

