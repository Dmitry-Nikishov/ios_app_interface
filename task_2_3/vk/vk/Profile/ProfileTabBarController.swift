//
//  ProfileTabBarController.swift
//  vk
//
//  Created by Дмитрий Никишов on 01.12.2021.
//

import UIKit

class ProfileTabBarController : UITabBarController,
                         UITabBarControllerDelegate,
                         Coordinating {
    var coordinator: Coordinator? {
        didSet {
            profileViewController.coordinator = coordinator
        }
    }
    
    private(set) lazy var coreDataStack = CoreDataStack()
    
    private lazy var profileViewController = ProfileViewController(
    statusModel : UserStatusModel(policy : .onlyLettersPossible),
    stack: coreDataStack)
    
    private lazy var bookmarkedViewController = BookmarkedViewController(stack : coreDataStack)
        
    public func setUserIdentity(userIdentity : User) {
        self.profileViewController.setUser(user: userIdentity)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        self.delegate = self
                
        setupVCs()
    }
        
    private func setupVCs()
    {
        viewControllers = [
            createNavController(for : profileViewController,
                                    title : "Profile",
                                    image : UIImage(systemName: "note")!),
            
            createNavController(for : bookmarkedViewController,
                                    title : "Marked Posts",
                                    image : UIImage(systemName: "bookmark")!)
        ]
    }
    
    private func createNavController(for rootViewController : UIViewController,
                                     title : String,
                                     image : UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
}
