//
//  DaySummaryController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 06.01.2022.
//

import UIKit

class DaySummaryController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private func setupView()
    {
        let daySummaryView = DaySummaryView(viewFrame: self.view.frame)
        
        daySummaryView.backButtonHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .daySummaryViewToMainViewEvent)
        }
        
        self.view = daySummaryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

