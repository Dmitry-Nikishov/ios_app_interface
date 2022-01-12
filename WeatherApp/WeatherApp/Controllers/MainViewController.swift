//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class MainViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private func setupView()
    {
        let mainView = MainView(viewFrame: self.view.frame)
        
        mainView.menuClickHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .mainViewToSettingsViewEvent)
        }
        
        mainView.perDayClickHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .mainViewToDaySummaryViewEvent)
        }
        
        mainView.per24ClickHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .mainViewToHourSummaryViewEvent)
        }
        
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
    }
}

