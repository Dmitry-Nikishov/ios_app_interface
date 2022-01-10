//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class MainViewController : UIViewController {
    private func setupView()
    {
        let mainView = MainView(viewFrame: self.view.frame)
        
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

