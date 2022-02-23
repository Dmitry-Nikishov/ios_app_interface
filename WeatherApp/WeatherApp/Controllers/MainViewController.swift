//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class MainViewController : UIViewController, Coordinating {
    weak var coordinator: Coordinator?

    private(set) lazy var currentLocationProvider = CurrentLocationProvider()
    
    private var customView : MainView {
        return view as! MainView
    }
    
    private let weatherDataProvider = WeatherDataProvider.shared
    
    private var latestHourlyData : WeatherDataHourly?
    private var latestMonthlyData : WeatherDataMonthly?
    private var latestOneDayData : WeatherDataOneDay?
    
    private var latestPoiName : String?

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
            if self?.customView.existingGeoPoints == 0 {
                self?.setupView(geoItems: [poiName])
                self?.view.layoutIfNeeded()
            } else {
                self?.customView.addNewCity(cityName: poiName)
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
        let mainView = MainView(viewFrame: .zero,
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
        
    private func updateOneDayView()
    {
        if let weatherData = latestOneDayData {
            let uiData = WeatherDataToUiRepresentationConverter.convertOneDayData(data: weatherData)

            DispatchQueue.main.async { [weak self] in
                self?.customView.applyModelData(dataForUi: uiData)
            }
        }
    }
    
    private func updateHourlyView()
    {
        if let weatherData = latestHourlyData {
            let uiData = WeatherDataToUiRepresentationConverter.convertPerHourDataToUiPerHourCollectionData(data: weatherData)

            DispatchQueue.main.async { [weak self] in
                self?.customView.applyModelData(dataForUi: uiData)
            }
        }
    }
    
    private func updateMonthlyView()
    {
        if let weatherData = latestMonthlyData {
            let uiData = WeatherDataToUiRepresentationConverter.convertMonthlyDataToUiCollectionData(data: weatherData)

            DispatchQueue.main.async { [weak self] in
                self?.customView.applyModelData(dataForUi: uiData)
            }
        }
    }
    
    private func updateUiWithWeatherData(poiName : String)
    {
        latestPoiName = poiName
        
        weatherDataProvider.getOneDayData(poi: poiName) { [weak self] weatherData in
            self?.latestOneDayData = weatherData
            self?.updateOneDayView()
        }
        
        weatherDataProvider.getHourlyData(poi: poiName) { [weak self] weatherData in
            self?.latestHourlyData = weatherData
            self?.updateHourlyView()
        }

        weatherDataProvider.getMonthlyData(poi: poiName) { [weak self] weatherData in
            self?.latestMonthlyData = weatherData
            self?.updateMonthlyView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let geoLocations = getGeoItemNames(mode: self.setupMode)
        setupView(geoItems: geoLocations)

        if self.setupMode == .withCurrentLocation {
            currentLocationProvider.locationUpdateCallback = { [weak self] location in
                if self?.isGeoPointReceived == false {
                    let dbGeoPoint = DbGeoPoint(id: AppCommonStrings.currentLocationLabel,
                                            latitude: Float(location.coordinate.latitude),
                                            longitude: Float(location.coordinate.longitude))

                    GeoPointsDB.shared.addGeoPoint(geoPoint: dbGeoPoint)
                    
                    self?.updateViewAfterAddingNewPoi(poiName: AppCommonStrings.currentLocationLabel)
                    
                    self?.isGeoPointReceived = true
                }
            }

            currentLocationProvider.updateLocation()
        }
    }
    
    private var isGeoPointReceived : Bool = false
    private var setupMode : OnboardingMode = .withoutCurrentLocation
        
    func setupViewForMode(_ mode : OnboardingMode)
    {
        self.setupMode = mode
    }

    public func refreshAfterSettingsChange()
    {
        updateOneDayView()
        updateHourlyView()
        updateMonthlyView()
    }
}

