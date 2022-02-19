//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 20.12.2021.
//

import UIKit

class SettingsViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private func setupView()
    {
        let settingsView = SettingsView(viewFrame: self.view.frame)
        
        settingsView.applySettingsHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .settingsViewToMainViewEvent)
        }
        
        self.view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}
