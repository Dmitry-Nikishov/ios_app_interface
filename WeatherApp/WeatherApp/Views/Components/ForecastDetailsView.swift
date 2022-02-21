//
//  ForecastDetailsView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 07.01.2022.
//

import UIKit

class ForecastDetailsView : UIView
{
    public var ViewLabel : String? {
        didSet {
            viewLabel.text = ViewLabel ?? ""
        }
    }
    
    public var WeatherStatusLabel : String? {
        didSet {
            weatherStatusLabel.text = WeatherStatusLabel ?? ""
        }
    }
    
    public var DegreeValue : String? {
        didSet {
            degreeLabel.text = DegreeValue
        }
    }
    
    private let degreeLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "13°"
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    
    private let viewLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "День"
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()

    private let weatherStatusLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Ливень"
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    
    private let weatherImage : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "shower")
        view.tintColor = .blue
        return view
    }()
    
    private let detailsArea : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1).cgColor
        return view
    }()
    
    private let detailsStackView : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    private let row1Area : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        return view
    }()

    private let row2Area : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        return view
    }()

    private let row3Area : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        return view
    }()

    private let row4Area : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        return view
    }()

    private let row5Area : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        return view
    }()

    var feelsLikeTemperature : String {
        get {
            return row1DetailView.RowLabel ?? ""
        }
        
        set(newValue) {
            row1DetailView.RowData = newValue
        }
    }
    
    private let row1DetailView : WeatherDetailRowView = {
        let view = WeatherDetailRowView(viewFrame: .zero)
        view.RowImage = UIImage(named: "thermometer")
        view.RowLabel = "По ощущениям"
        view.RowData = "0°"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view;
    }()

    var windSpeed : String {
        get {
            return row2DetailView.RowData ?? ""
        }
        
        set(newValue) {
            row2DetailView.RowData = newValue
        }
    }
    
    private let row2DetailView : WeatherDetailRowView = {
        let view = WeatherDetailRowView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.RowImage = UIImage(named: "wind")
        view.RowLabel = "Ветер"
        view.RowData = "5 m/s ЗЮЗ"
        return view;
    }()

    var ufIndex : String {
        get {
            return row3DetailView.RowData ?? ""
        }
        
        set(newValue) {
            row3DetailView.RowData = newValue
        }
    }

    private let row3DetailView : WeatherDetailRowView = {
        let view = WeatherDetailRowView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.RowImage = UIImage(named: "sunny")
        view.RowLabel = "Уф индекс"
        view.RowData = "4(умерен)"
        return view;
    }()

    var humidity : String {
        get {
            return row4DetailView.RowData ?? ""
        }
        
        set(newValue) {
            row4DetailView.RowData = newValue
        }
    }

    private let row4DetailView : WeatherDetailRowView = {
        let view = WeatherDetailRowView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.RowImage = UIImage(named: "shower")
        view.RowLabel = "Дождь"
        view.RowData = "55%"
        return view;
    }()

    var cloudy : String {
        get {
            return row5DetailView.RowData ?? ""
        }
        
        set(newValue) {
            row5DetailView.RowData = newValue
        }
    }

    private let row5DetailView : WeatherDetailRowView = {
        let view = WeatherDetailRowView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.RowImage = UIImage(named: "cloud")
        view.RowLabel = "Облачность"
        view.RowData = "72%"
        return view;
    }()

    private func setDetailsStackView()
    {
        LayoutAssembler.fillAreaWithView(area: detailsArea, filler: detailsStackView)

        NSLayoutConstraint.activate(constraints)

        detailsStackView.addArrangedSubview(row1Area)
        detailsStackView.addArrangedSubview(row2Area)
        detailsStackView.addArrangedSubview(row3Area)
        detailsStackView.addArrangedSubview(row4Area)
        detailsStackView.addArrangedSubview(row5Area)
        
        LayoutAssembler.fillAreaWithView(area: row1Area, filler: row1DetailView)
        LayoutAssembler.fillAreaWithView(area: row2Area, filler: row2DetailView)
        LayoutAssembler.fillAreaWithView(area: row3Area, filler: row3DetailView)
        LayoutAssembler.fillAreaWithView(area: row4Area, filler: row4DetailView)
        LayoutAssembler.fillAreaWithView(area: row5Area, filler: row5DetailView)
    }
    
    private func setupWeatherImage()
    {
        addSubview(weatherImage)
        
        let constraints = [
            weatherImage.centerXAnchor.constraint(equalTo: weatherStatusLabel.leadingAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 26),
            weatherImage.heightAnchor.constraint(equalToConstant: 32),
            weatherImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupDegreeLabel()
    {
        addSubview(degreeLabel)
        
        let constraints = [
            degreeLabel.leadingAnchor.constraint(equalTo: weatherStatusLabel.centerXAnchor),
            degreeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            degreeLabel.widthAnchor.constraint(equalToConstant: 32),
            degreeLabel.heightAnchor.constraint(equalToConstant: 36)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupWeatherStatusLabel()
    {
        addSubview(weatherStatusLabel)
        
        let constraints = [
            weatherStatusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 62),
            weatherStatusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherStatusLabel.heightAnchor.constraint(equalToConstant: 22),
            weatherStatusLabel.widthAnchor.constraint(equalToConstant: 160)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    private func setupDetailsArea()
    {
        addSubview(detailsArea)
        
        let constraints = [
            detailsArea.topAnchor.constraint(equalTo: self.topAnchor, constant: 112),
            detailsArea.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailsArea.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            detailsArea.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupViewLabel()
    {
        addSubview(viewLabel)
        
        let constraints = [
            viewLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            viewLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            viewLabel.widthAnchor.constraint(equalToConstant: 44),
            viewLabel.heightAnchor.constraint(equalToConstant: 22)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupLayout()
    {
        setupViewLabel()
        setupWeatherStatusLabel()
        setupDegreeLabel()
        setupWeatherImage()
        setupDetailsArea()
        setDetailsStackView()
    }
    
    private func setupViews()
    {
        self.layer.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1).cgColor
     
        setupLayout()
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for ForecastDetailsView")
    }
}
