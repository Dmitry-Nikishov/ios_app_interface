//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 18.12.2021.
//

import UIKit

class OnboardingViewController: UIViewController, Coordinating {
    weak var coordinator: Coordinator?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let onboardingView = OnboardingView(viewFrame: .zero)
        onboardingView.useGeolocationClickHandler = { [unowned self] in
            self.coordinator?.processEvent(with: .onboardingViewToMainViewEvent(.withCurrentLocation))
        }
        
        onboardingView.denyGeolocationClickHandler = { [unowned self] in
            self.coordinator?.processEvent(with: .onboardingViewToMainViewEvent(.withoutCurrentLocation))
        }
        
        self.view = onboardingView
    }
}

