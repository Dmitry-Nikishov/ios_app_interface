//
//  DaySummaryController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 06.01.2022.
//

import UIKit

class DaySummaryController : UIViewController {
    private func setupView()
    {
        let daySummaryView = DaySummaryView(viewFrame: self.view.frame)
        
        self.view = daySummaryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

