//
//  DayDisplayView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class DayDisplayView : UIView
{
    private let sunriseImage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sunrise")
        view.contentMode = .scaleAspectFit
        view.tintColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sunsetImage : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "sunset")
        view.tintColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sunriseTimeLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textColor = .white
        view.text = "05:41"
        view.textAlignment = .center
        return view
    }()

    private let sunsetTimeLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textColor = .white
        view.text = "19:31"
        view.textAlignment = .center
        return view
    }()
    
    private let calendarTimeLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .yellow
        view.textAlignment = .center
        view.text = "17:48, пт 16 апреля"
        return view
    }()

    private let minMaxTemperatureLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .white
        view.textAlignment = .center
        view.text = "7°/13°"
        view.layer.zPosition = 2
        return view
    }()

    private let currentTemperatureLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 36)
        view.textColor = .white
        view.textAlignment = .center
        view.text = "13°"
        view.layer.zPosition = 2
        return view
    }()

    private let forecastLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .white
        view.textAlignment = .center
        view.text = "Возможен небольшой дождь"
        view.layer.zPosition = 2
        return view
    }()
    
    private let auxWeatherInfo : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 2
        view.layer.zPosition = 2
        return view
    }()

    private let feelTemperatureImage : UIImageView = {
        let itemImageLabel = UIImageView()
        itemImageLabel.image = UIImage(named: "cloud_with_sun")
        itemImageLabel.contentMode = .scaleAspectFit
        itemImageLabel.translatesAutoresizingMaskIntoConstraints = false
        itemImageLabel.layer.zPosition = 2
        return itemImageLabel
    }()
    
    private let feelTemperatureLabel : UILabel = {
        let itemLabel = UILabel()
        itemLabel.textAlignment = .center
        itemLabel.font = UIFont.systemFont(ofSize: 14)
        itemLabel.text = "0"
        itemLabel.textColor = .white
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.layer.zPosition = 2
        return itemLabel
    }()
    
    private let feelTemperatureItem : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 2
        view.spacing = 0
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()

    private let windSpeedImage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wind")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 2
        return view
    }()
    
    private let windSpeedLabel : UILabel = {
        let itemLabel = UILabel()
        itemLabel.textAlignment = .center
        itemLabel.font = UIFont.systemFont(ofSize: 14)
        itemLabel.text = "3 м/с"
        itemLabel.textColor = .white
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.layer.zPosition = 2
        return itemLabel
    }()

    private let windSpeedItem : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 2
        view.spacing = 0
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private let percipitationLabelImage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "percipitation")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 2
        return view
    }()
    
    private let percipitationLabel : UILabel = {
        let itemLabel = UILabel()
        itemLabel.textAlignment = .center
        itemLabel.font = UIFont.systemFont(ofSize: 14)
        itemLabel.text = "75 %"
        itemLabel.textColor = .white
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.layer.zPosition = 2
        return itemLabel
    }()

    private let perticipationItem : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 2
        view.spacing = 0
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()

    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()

        path.addArc(withCenter: CGPoint(x: 0, y: 0),
                    radius: UIScreen.main.bounds.width/2 - 16 - 36,
                    startAngle: 0,
                    endAngle: Double.pi,
                    clockwise: false)
        return path
    }

    private func drawArc() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath().cgPath
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.fillColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.position = CGPoint(x: UIScreen.main.bounds.width/2, y: 160)
        
        self.layer.addSublayer(shapeLayer)
    }
    
    private func setupLayout()
    {
        self.addSubview(sunriseImage)
        self.addSubview(sunsetImage)
        self.addSubview(sunriseTimeLabel)
        self.addSubview(sunsetTimeLabel)
        self.addSubview(calendarTimeLabel)
        self.addSubview(minMaxTemperatureLabel)
        self.addSubview(currentTemperatureLabel)
        self.addSubview(forecastLabel)
        self.addSubview(auxWeatherInfo)
        
        auxWeatherInfo.addArrangedSubview(feelTemperatureItem)
        auxWeatherInfo.addArrangedSubview(windSpeedItem)
        auxWeatherInfo.addArrangedSubview(perticipationItem)
        
        feelTemperatureItem.addArrangedSubview(feelTemperatureImage)
        feelTemperatureItem.addArrangedSubview(feelTemperatureLabel)
        
        windSpeedItem.addArrangedSubview(windSpeedImage)
        windSpeedItem.addArrangedSubview(windSpeedLabel)
        
        perticipationItem.addArrangedSubview(percipitationLabelImage)
        perticipationItem.addArrangedSubview(percipitationLabel)
        
        let constraints = [
            sunriseImage.widthAnchor.constraint(equalToConstant: 20),
            sunriseImage.heightAnchor.constraint(equalToConstant: 25),
            sunriseImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 42),
            sunriseImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 160),
            
            sunsetImage.heightAnchor.constraint(equalToConstant: 25),
            sunsetImage.widthAnchor.constraint(equalToConstant: 20),
            sunsetImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -42),
            sunsetImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 160),
            
            sunriseTimeLabel.centerXAnchor.constraint(equalTo: sunriseImage.centerXAnchor),
            sunriseTimeLabel.topAnchor.constraint(equalTo: sunriseImage.bottomAnchor),
            sunriseTimeLabel.widthAnchor.constraint(equalToConstant: 64),
            sunriseTimeLabel.heightAnchor.constraint(equalToConstant: 19),
            
            sunsetTimeLabel.centerXAnchor.constraint(equalTo: sunsetImage.centerXAnchor),
            sunsetTimeLabel.topAnchor.constraint(equalTo: sunsetImage.bottomAnchor),
            sunsetTimeLabel.widthAnchor.constraint(equalToConstant: 64),
            sunsetTimeLabel.heightAnchor.constraint(equalToConstant: 19),
            
            calendarTimeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            calendarTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            calendarTimeLabel.heightAnchor.constraint(equalToConstant: 20),
            calendarTimeLabel.widthAnchor.constraint(equalToConstant: 150),
            
            minMaxTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            minMaxTemperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            minMaxTemperatureLabel.widthAnchor.constraint(equalToConstant: 64),
            minMaxTemperatureLabel.heightAnchor.constraint(equalToConstant: 20),
            
            currentTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            currentTemperatureLabel.topAnchor.constraint(equalTo: minMaxTemperatureLabel.bottomAnchor, constant: 16),
            currentTemperatureLabel.widthAnchor.constraint(equalToConstant: 64),
            currentTemperatureLabel.heightAnchor.constraint(equalToConstant: 40),

            forecastLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            forecastLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 16),
            forecastLabel.heightAnchor.constraint(equalToConstant: 20),
            forecastLabel.widthAnchor.constraint(equalToConstant: 227),
            
            auxWeatherInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            auxWeatherInfo.centerYAnchor.constraint(equalTo: sunriseImage.topAnchor),
            auxWeatherInfo.widthAnchor.constraint(equalToConstant: 240),
            auxWeatherInfo.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupViews()
    {
        backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        layer.cornerRadius = 5
        
        setupLayout()
        
        drawArc()
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for DayDisplayView")
    }
}
