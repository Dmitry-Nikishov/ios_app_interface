//
//  HourSummaryViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 10.01.2022.
//

import UIKit

class HourSummaryViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private func setupView()
    {
        let hourSummaryView = HourSummaryView(viewFrame: self.view.frame)
        
        hourSummaryView.backButtonHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .hourSummaryViewToMainViewEvent)
        }
        
        self.view = hourSummaryView
    }

    func applyUiSettings(poiName : String?, dataForUi : WeatherDataHourly?)
    {
        let uiData = WeatherDataToUiRepresentationConverter.convertHourlyDataToHourlyControllerFormat(dataForUi: dataForUi)
        
        if let ui = self.view as? HourSummaryView {
            ui.applyUiData(poiName: poiName, uiData: uiData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

