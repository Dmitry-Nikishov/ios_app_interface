//
//  TabBarViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 09.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    private let profileViewController = ProfileViewController()
    private let currentUser = User(fullName: "usr",
                                   avatarPath: "avatar",
                                   status: "waiting...")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        
        setupVCs()
    }
    
    
    func setupVCs()
    {
        viewControllers = [
            createNavController(for : LogInViewController( { (userNameInput : String) in
                #if DEBUG
                    self.profileViewController.setUser(
                        userService: TestUserService(),
                        userName: userNameInput
                    )
                #else
                    self.profileViewController.setUser(
                        userService: CurrentUserService(user: self.currentUser),
                        userName: userNameInput
                    )
                #endif
                
                self.selectedIndex = 1
            }), title: "Login", image : UIImage(systemName: "person.fill")!),
            
            createNavController(for : profileViewController, title: "Feed", image : UIImage(systemName: "homekit")!)
        ]
    }

    fileprivate func createNavController(for rootViewController : UIViewController,
                                         title : String,
                                         image : UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }

}
