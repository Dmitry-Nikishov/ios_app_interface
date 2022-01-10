//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 20.12.2021.
//

import UIKit

class SettingsViewController : UIViewController {
    private func setupView()
    {
        let settingsView = SettingsView(viewFrame: self.view.frame)
        
        self.view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}
