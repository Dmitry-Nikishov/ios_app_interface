//
//  ViewController.swift
//  MapKit
//
//  Created by Дмитрий Никишов on 16.02.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    private var currentLocation : CLLocationCoordinate2D?

    private let locationManager = CLLocationManager()
    
    private func setupView()
    {
        let mainView = MainView(viewFrame: self.view.frame)
        self.view = mainView
    }
    
    private func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func showAlert(title : String, message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (_) in
            
             }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func makeRoute()
    {
        guard let current = self.currentLocation else {return}
        
        if let ui = self.view as? MainView {
            let request = MKDirections.Request()
            
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: current))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: ui.pinCoordinates[0]))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculate { [weak ui] response, error in
                guard let response = response else {return}
                
                if let route = response.routes.first {
                    ui?.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    let rect = route.polyline.boundingMapRect
                    ui?.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                }
            }
        }
    }
    
    private func setupMenu()
    {
        let removeMapPinsItem = UIAction(title: "Remove Map Pins", image: UIImage(systemName: "minus.circle")) { [unowned self] (action) in
            if let ui = self.view as? MainView {
                let annotations = ui.mapView.annotations.filter({ !($0 is MKUserLocation) })
                ui.mapView.removeAnnotations(annotations)
                ui.pinCoordinates.removeAll()
            }
        }

        let deleteRouteItem = UIAction(title: "Delete Routes", image: UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up")) { [unowned self] (action) in
            if let ui = self.view as? MainView {
                let currentOverlays = ui.mapView.overlays(in: .aboveRoads)
                ui.mapView.removeOverlays(currentOverlays)
             
                if let myCurrentLocation = self.currentLocation {
                    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    let region = MKCoordinateRegion(center: myCurrentLocation, span: span)
                    
                    ui.mapView.setRegion(region, animated: true)
                }
            }
        }

        let createRouteItem = UIAction(title: "Create Route", image: UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up")) { [unowned self ] (action) in
            if let ui = self.view as? MainView {
                let annotations = ui.mapView.annotations.filter({ !($0 is MKUserLocation) })
                
                if annotations.count != 1 || currentLocation == nil {
                    self.showAlert(title: "Create Route Alert", message: "Not able to route to more than 1 pin or current location is nil")
                } else {
                    makeRoute()
                }
            }
        }

        let menu = UIMenu(title: "Map Menu",
                          options: .displayInline,
                          children: [removeMapPinsItem,
                                     createRouteItem,
                                     deleteRouteItem])

        let navItems = [
            UIBarButtonItem(systemItem: .edit , menu: menu)
        ]

        self.navigationItem.leftBarButtonItems = navItems
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocationManager()
        setupMenu()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(
            latitude: locations[0].coordinate.latitude,
            longitude: locations[0].coordinate.longitude)
        
        self.currentLocation = location
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        if let ui = self.view as? MainView {
            ui.mapView.setRegion(region, animated: true)
        }
    }
}

