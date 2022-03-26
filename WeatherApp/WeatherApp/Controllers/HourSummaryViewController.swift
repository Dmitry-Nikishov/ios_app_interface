//
//  HourSummaryViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 10.01.2022.
//

import UIKit

class HourSummaryViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private var customView : HourSummaryView {
        return view as! HourSummaryView
    }
    
    func applyUiSettings(poiName : String?, dataForUi : WeatherDataHourly?)
    {
        let uiData = WeatherDataToUiRepresentationConverter.convertHourlyDataToHourlyControllerFormat(dataForUi: dataForUi)
        
        self.customView.applyUiData(poiName: poiName, uiData: uiData)        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let hourSummaryView = HourSummaryView(viewFrame: .zero)
        
        hourSummaryView.backButtonHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .hourSummaryViewToMainViewEvent)
        }
        
        self.view = hourSummaryView
    }
}

