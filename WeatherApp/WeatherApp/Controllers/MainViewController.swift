//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class MainViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private var geoLocations : [String] = []
    
    private let addLocationPopup : AddNewLocationPopup = AddNewLocationPopup()
    
    private(set) lazy var currentLocationProvider: CurrentLocationProvider = {
        return CurrentLocationProvider()
    }()
    
    private var currentPosition : GeoPosition?
    
    private func getGeoPositionFromDb(poiName : String) -> GeoPosition?
    {
        if let dbGeoPoint = GeoPointsDB.shared.getGeoPoint(id: poiName) {
            return GeoPosition(latitude: dbGeoPoint.latitude,
                               longitude: dbGeoPoint.longitude)
        } else {
            return nil
        }
    }
    
    private func getCurrentGeoPositionOnceReady() -> GeoPosition? {
        self.taskGroup.wait()
        return currentPosition
    }
    
    private func getGeoItemNames(mode : OnboardingMode) -> [String] {
        var geoItems : [String] = []
        if mode == .withCurrentLocation {
            geoItems.append(AppCommonStrings.currentLocationLabel)
        }
        
        let availableGeoPointsInDb = GeoPointsDB.shared.getGeoPoints()
        if availableGeoPointsInDb.count > 0 {
            geoItems.append(contentsOf: availableGeoPointsInDb.compactMap{$0.id} )
        }
        
        return geoItems
    }
    
    private func setupView(geoItems : [String])
    {
        let mainView = MainView(viewFrame: self.view.frame,
                                geoPoints: geoItems)

        mainView.menuClickHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .mainViewToSettingsViewEvent)
        }
        
        mainView.perDayClickHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .mainViewToDaySummaryViewEvent)
        }
        
        mainView.per24ClickHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .mainViewToHourSummaryViewEvent)
        }
        
        mainView.addLocationClickHandler = { [weak self] in
            if let popUp = self?.addLocationPopup {
                popUp.modalPresentationStyle = .overCurrentContext
                popUp.modalTransitionStyle = .crossDissolve
                self?.present(popUp, animated: true, completion: nil)
            }
        }
        
        mainView.updateWeatherDataRequestHandler = { [weak self] poiName in
            self?.updateUiWithWeatherData(poiName: poiName)
        }
        
        self.view = mainView
        
        if !geoItems.isEmpty {
            updateUiWithWeatherData(poiName: mainView.currentGeoPoint)
        }
    }

    private func getDataForGeoPositionAndUpdateUi(geoPosition : GeoPosition) {
        DispatchQueue.global().async { [weak self] in
            let latitudeString = "\(geoPosition.latitude)"
            let longitudeString = "\(geoPosition.longitude)"

            WeatherClient.shared.getOneDayForecast(latitude: latitudeString,
                                                   longitude: longitudeString) { [weak self] weatherData in
                if let weatherData = weatherData {
                    let uiData = WeatherDataToUiRepresentationConverter.convertOneDayData(data: weatherData)

                    DispatchQueue.main.async { [weak self] in
                        if let ui = self?.view as? MainView {
                            ui.applyModelData(dataForUi: uiData)
                        }
                    }
                }
            }
            
            WeatherClient.shared.getHourlyForecast(latitude: latitudeString,
                                                   longitude: longitudeString) { [weak self] weatherData in
                if let weatherData = weatherData {
                    let uiData = WeatherDataToUiRepresentationConverter.convertPerHourDataToUiPerHourCollectionData(data: weatherData)

                    DispatchQueue.main.async { [weak self] in
                        if let ui = self?.view as? MainView {
                            ui.applyModelData(dataForUi: uiData)
                        }
                    }
                }
            }
            
            WeatherClient.shared.getMonthlyForecast(latitude: latitudeString,
                                                    longitude: longitudeString) { [weak self] weatherData in
                if let weatherData = weatherData {
                    let uiData = WeatherDataToUiRepresentationConverter.convertMonthlyDataToUiCollectionData(data: weatherData)

                    DispatchQueue.main.async { [weak self] in
                        if let ui = self?.view as? MainView {
                            ui.applyModelData(dataForUi: uiData)
                        }
                    }
                }
            }
        }
    }
    
    private func updateUiWithWeatherData(poiName : String)
    {
        if poiName == AppCommonStrings.currentLocationLabel {
            DispatchQueue.global().async { [weak self] in
                if let geoPosition = self?.getCurrentGeoPositionOnceReady() {
                    self?.getDataForGeoPositionAndUpdateUi(geoPosition: geoPosition)
                }
            }
        } else {
            if let geoPosition = getGeoPositionFromDb(poiName: poiName) {
                getDataForGeoPositionAndUpdateUi(geoPosition: geoPosition)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let taskGroup = DispatchGroup()
    
    func setupViewForMode(_ mode : OnboardingMode)
    {
        if mode == .withCurrentLocation {
            taskGroup.enter()
            currentLocationProvider.locationUpdateCallback = { [weak self] location in
                let leaveTaskGroup = self?.currentPosition == nil
                self?.currentPosition = GeoPosition(latitude: Float(location.coordinate.latitude),
                                                    longitude: Float(location.coordinate.longitude))
                
                if leaveTaskGroup {
                    self?.taskGroup.leave()
                }
            }
            
            currentLocationProvider.updateLocation()
        }

        geoLocations = getGeoItemNames(mode: mode)
        setupView(geoItems: geoLocations)
        
        addLocationPopup.closePopupHandler = { [weak self] newLocationName in
            guard let this = self else { return }
            this.geoLocations.append(newLocationName)
            this.setupView(geoItems: this.geoLocations)
        }
    }
}

