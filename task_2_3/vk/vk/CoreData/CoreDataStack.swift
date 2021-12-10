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
    
    private var backgroundContext : NSManagedObjectContext?
    
    private var viewContext: NSManagedObjectContext?
    
    init() {
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext = persistentContainer.viewContext
    }
        
    func fetchDbPosts() -> [PostDb] {
        var result : [PostDb] = []
        
        DispatchQueue.global(qos: .background).sync { [weak self] in
            guard let this = self else {return}
            result = this.fetchDbPostsImpl()
        }
        
        return result
    }
    
    private func fetchDbPostsImpl() -> [PostDb] {
        guard let backgroundContext = backgroundContext else {return []}
        
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

    func fetchDbPostsByAuthor(author : String) -> [PostDb] {
        var result : [PostDb] = []
        
        DispatchQueue.global(qos: .background).sync { [weak self] in
            guard let this = self else {return}
            result = this.fetchDbPostsByAuthorImpl(author: author)
        }
        
        return result
    }

    
    private func fetchDbPostsByAuthorImpl(author : String) -> [PostDb] {
        guard let backgroundContext = backgroundContext else {return []}
        
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
        DispatchQueue.global(qos: .background).sync { [weak self] in
            guard let this = self else {return}
            this.removeImpl(post: post)
        }
    }
    
    private func removeImpl(post: PostDb) {
        guard let backgroundContext = backgroundContext else {return}
        backgroundContext.performAndWait {
            backgroundContext.delete(post)
            save(context: backgroundContext)
        }
    }

    func createNewPost(post : Post) {
        DispatchQueue.global(qos: .background).sync { [weak self] in
            guard let this = self else {return}
            this.createNewPostImpl(post: post)
        }
    }
    
    private func createNewPostImpl(post: Post) {
        guard let backgroundContext = backgroundContext else {return}
        
        let newPost = PostDb(context: backgroundContext)
        newPost.image = post.image
        newPost.author = post.author
        newPost.likes = Int32(post.likes)
        newPost.views = Int32(post.views)
        newPost.content = post.description

        save(context: backgroundContext)
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
