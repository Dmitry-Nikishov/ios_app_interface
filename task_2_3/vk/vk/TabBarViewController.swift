//
//  TabBarViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 09.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    #if DEBUG
        private let profileViewController = ProfileViewController(TestUserService())
    #else
    private let profileViewController = ProfileViewController(CurrentUserService(user:PredefinedUsers.currentUser))

    #endif

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        
        setupVCs()
    }
    
    private func showInvalidUserAlert()
    {
        let alert = UIAlertController(title: "VK App", message: "Invalid user name. Try again", preferredStyle: .alert)
            
        let ok = UIAlertAction(title: "OK", style: .default)

        alert.addAction(ok)
        
        self.present(alert, animated: true)
    }
    
    func setupVCs()
    {
        viewControllers = [
            createNavController(for : LogInViewController( { (userNameInput : String) in
                let userName = Utility.getUserName(
                    service: self.profileViewController.getControllerUserService(),
                    userName: userNameInput)
                                
                guard let usr = userName else {
                   self.showInvalidUserAlert()
                   return
                }
                
                self.profileViewController.setUser(user: usr)
                self.selectedIndex = 1
                self.setEnableStatusForFeedTabItem(true)
                                
            }), title: "Login", image : UIImage(systemName: "person.fill")!),
            
            createNavController(for : profileViewController, title: "Feed", image : UIImage(systemName: "homekit")!)
            
        ]
        
        setEnableStatusForFeedTabItem(false)
    }

    private func setEnableStatusForFeedTabItem(_ enabled : Bool) {
        tabBar.items?[1].isEnabled = enabled
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
