//
//  DaySummaryController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 06.01.2022.
//

import UIKit

class DaySummaryController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    func applyUiSettings(poiName : String?, weatherData : WeatherDataMonthly?)
    {
        if let dataForUi = weatherData {
            let uiData = WeatherDataToUiRepresentationConverter.convertMonthlyDataToUiRepresentation(weatherData: dataForUi)

            if let ui = self.view as? DaySummaryView {
                ui.applyUiSettings(poiName: poiName, uiData: uiData)
            }
        }
    }
    
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

