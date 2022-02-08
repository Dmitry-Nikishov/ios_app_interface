//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class MainViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
//    private let addLocationPopup : AddNewLocationPopup = AddNewLocationPopup()
    
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
        return currentPosition
    }
    
    private func getGeoItemNames(mode : OnboardingMode) -> [String] {
        let availableGeoPointsInDb = GeoPointsDB.shared.getGeoPoints()

        if mode == .withoutCurrentLocation {
            return availableGeoPointsInDb.compactMap{$0.id}.filter{$0 != AppCommonStrings.currentLocationLabel}
        } else {
            return availableGeoPointsInDb.compactMap{$0.id}
        }
    }
    
    private func showAddNewPoiDialog()
    {
        let alert = UIAlertController(title: "Добавить город", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            if let cityName = alert.textFields?.first?.text {
                let geoCode = YandexGeocoding.shared.getGeoCode(geocode: cityName)
                if let geoPosition = geoCode {
                    let dbGeoPoint = DbGeoPoint(id: cityName,
                                                latitude: geoPosition.latitude,
                                                longitude: geoPosition.longitude)
                    GeoPointsDB.shared.addGeoPoint(geoPoint: dbGeoPoint)
                    
                    DispatchQueue.main.async { [weak self] in
                        if let ui = self?.view as? MainView {
                            ui.addNewCity(cityName: cityName)
                        }
                    }
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "введите название города"
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
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
            self?.showAddNewPoiDialog()
        }
        
        mainView.updateWeatherDataRequestHandler = { [weak self] poiName in
//            self?.updateUiWithWeatherData(poiName: poiName)
        }
        
        self.view = mainView
        
        if !geoItems.isEmpty {
//            updateUiWithWeatherData(poiName: mainView.currentGeoPoint)
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
    
    func setupViewForMode(_ mode : OnboardingMode)
    {
        let geoLocations = getGeoItemNames(mode: mode)
        setupView(geoItems: geoLocations)
        
        if mode == .withCurrentLocation {
            currentLocationProvider.locationUpdateCallback = { location in

                let dbGeoPoint = DbGeoPoint(id: AppCommonStrings.currentLocationLabel,
                                        latitude: Float(location.coordinate.latitude),
                                        longitude: Float(location.coordinate.longitude))

                GeoPointsDB.shared.addGeoPoint(geoPoint: dbGeoPoint)

                DispatchQueue.main.async { [weak self] in
                    if let ui = self?.view as? MainView {
                        ui.addNewCity(cityName: AppCommonStrings.currentLocationLabel)
                    }
                }
            }

            currentLocationProvider.updateLocation()
        }
    }
}

