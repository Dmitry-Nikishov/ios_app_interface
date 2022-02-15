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
    
    private var backgroundContext : NSManagedObjectContext!
    
    private var viewContext: NSManagedObjectContext!
    
    init() {
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext = persistentContainer.viewContext
    }
        
    func fetchDbPosts() -> [PostDb] {
        let request: NSFetchRequest<PostDb> = PostDb.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("fetchDbPosts error")
        }
    }
    
    func fetchDbPostsByAuthor(author : String) -> [PostDb] {
        let request: NSFetchRequest<PostDb> = PostDb.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@", author)
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("fetchDbPostsByAuthor error")
        }
    }

    func remove(post : PostDb) {
        backgroundContext.perform { [weak self] in
            guard let this = self else {return}
            let recreatedObj = this.backgroundContext.object(with: post.objectID) as! PostDb
            this.backgroundContext.delete(recreatedObj)
            this.save(context: this.backgroundContext)
        }
    }

    func createNewPost(post : Post) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let this = self else {return}
            this.createNewPostImpl(post: post, context: this.backgroundContext)
        }
    }
    
    private func createNewPostImpl(post: Post, context : NSManagedObjectContext) {
        let newPost = PostDb(context: context)
        newPost.image = post.image
        newPost.author = post.author
        newPost.likes = Int32(post.likes)
        newPost.views = Int32(post.views)
        newPost.content = post.description

        save(context: context)
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
