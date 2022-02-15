//
//  TabBarController.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 25.11.2021.
//

import UIKit

class TabBarController : UITabBarController,
                         UITabBarControllerDelegate,
                         Coordinating {
    var coordinator: Coordinator?
    
    private let folderContentVC = FolderViewController()
    
    private let settingsViewVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        self.delegate = self
        
        let userDefaultsSetup = AppUserDefaults.getSettingsViewSetup()
        settingsViewVC.initialViewSetup = userDefaultsSetup
        folderContentVC.currentSettingsViewSetup = userDefaultsSetup
        
        setupVCs()
    }
        
    private func setupVCs()
    {
        viewControllers = [
            createNavController(for : folderContentVC,
                                    title : "Folder Content",
                                    image : UIImage(systemName: "folder")!),
            
            createNavController(for : settingsViewVC,
                                    title : "Settings",
                                    image : UIImage(systemName: "gearshape")!)
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
    
    //MARK:- UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)! {
            
            if selectedIndex == 0 {
                let setup = settingsViewVC.getCurrentViewSettings()
                folderContentVC.applySettingsViewSetup(setup: setup)
            }
        }
    }
}

