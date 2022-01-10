//
//  HourSummaryViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 10.01.2022.
//

import UIKit

class HourSummaryViewController : UIViewController {
    private func setupView()
    {
        let hourSummaryView = HourSummaryView(viewFrame: self.view.frame)
        
        self.view = hourSummaryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

