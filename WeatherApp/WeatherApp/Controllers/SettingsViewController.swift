//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 20.12.2021.
//

import UIKit

class SettingsViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let settingsView = SettingsView(viewFrame: .zero)
        
        settingsView.applySettingsHandler = { [unowned self] in
            self.coordinator?.processEvent(with: .settingsViewToMainViewEvent)
        }
        
        self.view = settingsView
    }
}
