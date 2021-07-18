//
//  TabBarViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 09.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

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
            createNavController(for : LogInViewController( {
                self.selectedIndex = 1
            }), title: "Login", image : UIImage(systemName: "person.fill")!),
            
            createNavController(for : ProfileViewController(), title: "Feed", image : UIImage(systemName: "homekit")!)
        ]
    }

    fileprivate func createNavController(for rootViewController : UIViewController,
                                         title : String,
                                         image : UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.isHidden = true
        return navController
    }

}
