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
    
    private var currentPosition : GeoPosition = GeoPosition(latitude: 0.0,
                                                            longitude: 0.0)
    
    private func getGeoItemNames(mode : OnboardingMode) -> [String] {
        var geoItems : [String] = []
        if mode == .withCurrentLocation {
            geoItems.append("Текущее")
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
        
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    func setupViewForMode(_ mode : OnboardingMode)
    {
        geoLocations = getGeoItemNames(mode: mode)
        setupView(geoItems: geoLocations)
        
        if mode == .withCurrentLocation {
            currentLocationProvider.locationUpdateCallback = { [weak self] location in
                self?.currentPosition = GeoPosition(latitude: Float(location.coordinate.latitude),
                                                    longitude: Float(location.coordinate.longitude))
            }
            
            currentLocationProvider.updateLocation()
        }
        
        addLocationPopup.closePopupHandler = { [weak self] newLocationName in
            guard let this = self else { return }
            this.geoLocations.append(newLocationName)
            this.setupView(geoItems: this.geoLocations)
        }
    }
}

