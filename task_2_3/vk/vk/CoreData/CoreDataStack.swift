//
//  CoreDataStack.swift
//  vk
//
//  Created by Дмитрий Никишов on 04.12.2021.
//

import CoreData
import StorageService

class CoreDataStack {
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DbPosts")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func fetchDbPosts() -> [PostDb] {
        let request: NSFetchRequest<PostDb> = PostDb.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("Fetch PostDb failure")
        }
    }

    func remove(post: PostDb) {
        viewContext.delete(post)

        save(context: viewContext)
    }

    func createNewPost(post: Post) {
        let newPost = PostDb(context: viewContext)
        newPost.image = post.image
        newPost.author = post.author
        newPost.likes = Int32(post.likes)
        newPost.views = Int32(post.views)
        newPost.content = post.description

        save(context: viewContext)
    }

    private func save(context: NSManagedObjectContext) {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
