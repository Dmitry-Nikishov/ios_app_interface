//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 18.12.2021.
//

import UIKit

class OnboardingViewController: UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private func setupView()
    {
        let onboardingView = OnboardingView(viewFrame: self.view.frame)
        onboardingView.useGeolocationClickHandler = { [weak self] in
            guard let this = self else {
                return
            }
            
            this.coordinator?.processEvent(with: .onboardingViewToMainViewEvent(.withCurrentLocation))
        }
        
        onboardingView.denyGeolocationClickHandler = { [weak self] in
            guard let this = self else {
                return
            }

            this.coordinator?.processEvent(with: .onboardingViewToMainViewEvent(.withoutCurrentLocation))
        }
        
        self.view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

