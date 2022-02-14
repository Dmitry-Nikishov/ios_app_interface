//
//  AirQualityDetailsView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 09.01.2022.
//

import UIKit

class AirQualityDetailsView : UIView
{
    public var AirQuality : String? {
        didSet {
            qualityLabel.text = AirQuality
        }
    }
    
    public var AirQualityEstimation : String? {
        didSet {
            qualityEstimationLabel.text = AirQualityEstimation
        }
    }
    
    private let viewLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Качество воздуха"
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()
    
    private let qualityLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "42"
        view.font = UIFont.boldSystemFont(ofSize: 28)
        return view
    }()
    
    private let qualityEstimationLabel : UILabel = {
        let view = PaddingLabel(withInsets: 0, 0, 8, 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor(red: 0.507, green: 0.792, blue: 0.501, alpha: 1).cgColor
        view.text = "хорошо"
        view.textColor = .white
        view.layer.cornerRadius = 5
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()

    private let qualityInfoLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Качество воздуха считается удовлетворительным и загрязнения воздуха представляются незначительными в пределах нормы"
        view.font = UIFont.systemFont(ofSize: 14)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return view
    }()

    private func setupView()
    {
        addSubview(viewLabel)
        addSubview(qualityLabel)
        addSubview(qualityEstimationLabel)
        addSubview(qualityInfoLabel)
        
        let constraints = [
            viewLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            viewLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            viewLabel.heightAnchor.constraint(equalToConstant: 22),
            
            qualityLabel.leadingAnchor.constraint(equalTo: viewLabel.leadingAnchor),
            qualityLabel.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 10),
            qualityLabel.heightAnchor.constraint(equalToConstant: 36),
            qualityLabel.widthAnchor.constraint(equalToConstant: 36),
            
            qualityEstimationLabel.centerYAnchor.constraint(equalTo: qualityLabel.centerYAnchor),
            qualityEstimationLabel.leadingAnchor.constraint(equalTo: qualityLabel.trailingAnchor, constant: 16),
            qualityEstimationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            qualityInfoLabel.leadingAnchor.constraint(equalTo: viewLabel.leadingAnchor),
            qualityInfoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            qualityInfoLabel.topAnchor.constraint(equalTo: qualityLabel.bottomAnchor),
            qualityInfoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    init(viewFrame : CGRect)
    {
        super.init(frame: viewFrame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented for AirQualityDetailsView")
    }
}
