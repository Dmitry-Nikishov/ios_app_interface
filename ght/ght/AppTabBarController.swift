//
//  AppTabBarController.swift
//  ght
//
//  Created by Дмитрий Никишов on 27.07.2021.
//

import UIKit

class AppTabBarController: UITabBarController {

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
            createNavController(for : HabitsViewController(),
                                title: "Привычки",
                                image : UIImage(systemName: "rectangle.grid.1x2.fill")!),
            
            createNavController(for : InfoViewController(),
                                title: "Информация",
                                image : UIImage(systemName: "info.circle.fill")!)
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
