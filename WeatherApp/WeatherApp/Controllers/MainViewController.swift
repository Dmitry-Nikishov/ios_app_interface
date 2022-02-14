//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class MainViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?

    private(set) lazy var currentLocationProvider: CurrentLocationProvider = {
        return CurrentLocationProvider()
    }()
    
    private func getGeoItemNames(mode : OnboardingMode) -> [String] {
        let availableGeoPointsInDb = GeoPointsDB.shared.getGeoPoints()

        if mode == .withoutCurrentLocation {
            return availableGeoPointsInDb.compactMap{$0.id}.filter{$0 != AppCommonStrings.currentLocationLabel}
        } else {
            return availableGeoPointsInDb.compactMap{$0.id}
        }
    }
    
    private func updateViewAfterAddingNewPoi(poiName : String)
    {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else {return}
            
            if let ui = this.view as? MainView {
                if ui.existingGeoPoints == 0 {
                    this.setupView(geoItems: [poiName])
                    this.view.layoutIfNeeded()
                } else {
                    ui.addNewCity(cityName: poiName)
                }
            }
        }
    }
    
    private func showAddNewPoiDialog()
    {
        let alert = UIAlertController(title: "Добавить город", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить", style: .default) { [weak self] action in
            if let cityName = alert.textFields?.first?.text {
                let geoCode = YandexGeocoding.shared.getGeoCode(geocode: cityName)
                if let geoPosition = geoCode {
                    let dbGeoPoint = DbGeoPoint(id: cityName,
                                                latitude: geoPosition.latitude,
                                                longitude: geoPosition.longitude)
                    GeoPointsDB.shared.addGeoPoint(geoPoint: dbGeoPoint)
                    
                    self?.updateViewAfterAddingNewPoi(poiName: cityName)
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
            self?.coordinator?.processEvent(with:
                    .mainViewToDaySummaryViewEvent(self?.latestPoiName, self?.latestMonthlyData))
        }
        
        mainView.per24ClickHandler = { [weak self] in
            self?.coordinator?.processEvent(with: .mainViewToHourSummaryViewEvent(self?.latestPoiName, self?.latestHourlyData))
        }
        
        mainView.addLocationClickHandler = { [weak self] in
            self?.showAddNewPoiDialog()
        }
        
        mainView.updateWeatherDataRequestHandler = { [weak self] poiName in
            self?.updateUiWithWeatherData(poiName: poiName)
        }
        
        self.view = mainView
        
        if !geoItems.isEmpty {
            updateUiWithWeatherData(poiName: mainView.currentGeoPoint)
        }
    }
    
    private let weatherDataProvider = WeatherDataProvider.shared
    
    private var latestHourlyData : WeatherDataHourly?
    private var latestMonthlyData : WeatherDataMonthly?
    private var latestPoiName : String?
    
    private func updateUiWithWeatherData(poiName : String)
    {
        latestPoiName = poiName
        
        weatherDataProvider.getOneDayData(poi: poiName) { weatherData in
            if let weatherData = weatherData {
                let uiData = WeatherDataToUiRepresentationConverter.convertOneDayData(data: weatherData)

                DispatchQueue.main.async { [weak self] in
                    if let ui = self?.view as? MainView {
                        ui.applyModelData(dataForUi: uiData)
                    }
                }
            }
        }
        
        weatherDataProvider.getHourlyData(poi: poiName) { [weak self] weatherData in
            self?.latestHourlyData = weatherData
            if let weatherData = weatherData {
                let uiData = WeatherDataToUiRepresentationConverter.convertPerHourDataToUiPerHourCollectionData(data: weatherData)

                DispatchQueue.main.async { [weak self] in
                    if let ui = self?.view as? MainView {
                        ui.applyModelData(dataForUi: uiData)
                    }
                }
            }
        }

        weatherDataProvider.getMonthlyData(poi: poiName) { [weak self] weatherData in
            self?.latestMonthlyData = weatherData
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViewInternals()
    }
    
    private var isGeoPointReceived : Bool = false
    private var setupMode : OnboardingMode = .withoutCurrentLocation
    
    private func loadViewInternals()
    {
        let geoLocations = getGeoItemNames(mode: self.setupMode)
        setupView(geoItems: geoLocations)

        if self.setupMode == .withCurrentLocation {
            currentLocationProvider.locationUpdateCallback = { [weak self] location in
                guard let this = self else { return }
                
                if this.isGeoPointReceived == false {
                    let dbGeoPoint = DbGeoPoint(id: AppCommonStrings.currentLocationLabel,
                                            latitude: Float(location.coordinate.latitude),
                                            longitude: Float(location.coordinate.longitude))

                    GeoPointsDB.shared.addGeoPoint(geoPoint: dbGeoPoint)
                    
                    self?.updateViewAfterAddingNewPoi(poiName: AppCommonStrings.currentLocationLabel)
                    
                    this.isGeoPointReceived = true
                }
            }

            currentLocationProvider.updateLocation()
        }
    }
    
    func setupViewForMode(_ mode : OnboardingMode)
    {
        self.setupMode = mode
    }
}

