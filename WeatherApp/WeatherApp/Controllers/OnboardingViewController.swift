//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 18.12.2021.
//

import UIKit

class OnboardingViewController: UIViewController {
    private func setupView()
    {
        let onboardingView = OnboardingView(viewFrame: self.view.frame)
//        onboardingView.useGeolocationClickHandler = {
//            print("use geo location")
//        }
//        
//        onboardingView.denyGeolocationClickHandler = {
//            print("deny geo location")
//        }
        
        self.view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

