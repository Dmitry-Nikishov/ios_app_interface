//
//  CoreDataStack.swift
//  vk
//
//  Created by Дмитрий Никишов on 04.12.2021.
//

import CoreData
import StorageService

class PersistentContainer {
    static let shared = PersistentContainer()

    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DbPosts")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private init() {}
    
    func getBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func getViewContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

class CoreDataStack {
    private var backgroundContext : NSManagedObjectContext
    
    private var viewContext: NSManagedObjectContext
    
    init() {
        backgroundContext = PersistentContainer.shared.getBackgroundContext()
        viewContext = PersistentContainer.shared.getViewContext()
    }
    
    func getBackgroundContext() -> NSManagedObjectContext {
        return backgroundContext
    }
    
    func getViewContext() -> NSManagedObjectContext {
        return viewContext
    }

    func fetchDbPostsViewContext() -> [PostDb] {
        let request: NSFetchRequest<PostDb> = PostDb.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("fetch view context error")
        }
    }
    
    func fetchDbPosts(handler : @escaping DbFetchHandler) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let this = self else {return}
            handler(this.fetchDbPostsImpl())
        }
    }
    
    func fetchDbPostsImpl() -> [PostDb] {
        var result : [PostDb] = []
        
        let request: NSFetchRequest<PostDb> = PostDb.fetchRequest()
        
        backgroundContext.performAndWait {
            do {
                result = try backgroundContext.fetch(request)
            } catch {
                fatalError("Fetch PostDb failure")
            }
        }
        
        return result
    }

    func fetchDbPostsByAuthor(author : String, handler : @escaping DbFetchHandler) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let this = self else {return}
            handler(this.fetchDbPostsByAuthorImpl(author: author))
        }
    }
    
    func fetchDbPostsByAuthorViewContext(author : String) -> [PostDb] {
        let request: NSFetchRequest<PostDb> = PostDb.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@", author)
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("fetch view context error")
        }
    }

    private func fetchDbPostsByAuthorImpl(author : String) -> [PostDb] {
        var result : [PostDb] = []
        
        let request: NSFetchRequest<PostDb> = PostDb.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@", author)

        backgroundContext.performAndWait {
            do {
                result = try backgroundContext.fetch(request)
            } catch {
                fatalError("Fetch PostDb failure")
            }
        }

        return result
    }

    func remove(post : PostDb) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let this = self else {return}
            this.removeImpl(post: post)
        }
    }
    
    func removeFromViewContext(post: PostDb) {
        viewContext.delete(post)
        save(context: viewContext)
    }
    
    private func removeImpl(post: PostDb) {
        backgroundContext.performAndWait {
            backgroundContext.delete(post)
            save(context: backgroundContext)
        }
    }

    func createNewPost(post : Post) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let this = self else {return}
            this.createNewPostImpl(post: post, context: this.backgroundContext)
        }
    }

    func createNewPostViewContext(post : Post) {
        createNewPostImpl(post: post, context: viewContext)
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
