//
//  DaySummaryView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 06.01.2022.
//

import UIKit

class DaySummaryView : UIView
{
    public var backButtonHandler : UiViewClickHandler?
    
    private var dayDetailsModelData : [UiMonthlyDayNightDetails] = []
    private var nightDetailsModelData : [UiMonthlyDayNightDetails] = []
    private var airQualityModelData : [UiMonthlyAirQuality] = []
    private var moonAndSunDetailsModelData : [UiMonthlySunAndMoonDetails] = []

    func applyUiSettings(poiName : String?, uiData : UiMonthlyData)
    {
        cityLabel.text = poiName
        dayDetailsModelData = uiData.dayDetails
        nightDetailsModelData = uiData.nightDetails
        airQualityModelData = uiData.airQuality
        moonAndSunDetailsModelData = uiData.moonAndSunDetails

        daySelectorViewItem.applyModelData(calendarDays: uiData.calendarDays.items)
    }
        
    @objc
    private func backButtonClicked()
    {
        backButtonHandler?()
    }
    
    private let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1), for: .normal)
        button.tintColor = .black
        button.setTitle("← Дневная погода", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(backButtonClicked), for:.touchUpInside)
        return button
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moscow, Russia"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func setupScrollView()
    {
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private let backButtonArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let cityLabelArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let daySelectorArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var daySelectorViewItem : DaySummarySelectorView = {
        let view = DaySummarySelectorView(viewFrame: .zero)
        view.selectedDayChanged = { [weak self] dayIndex in
            guard let this = self else {return}
            
            this.dayDetailsView.DegreeValue = this.dayDetailsModelData[dayIndex].temperature
            this.dayDetailsView.WeatherStatusLabel = this.dayDetailsModelData[dayIndex].description
            this.dayDetailsView.windSpeed = this.dayDetailsModelData[dayIndex].windSpeed
            this.dayDetailsView.humidity = this.dayDetailsModelData[dayIndex].humidity
            this.dayDetailsView.ufIndex = this.dayDetailsModelData[dayIndex].ufIndex
            this.dayDetailsView.cloudy = this.dayDetailsModelData[dayIndex].cloudy
            
            this.nightDetailsView.DegreeValue = this.nightDetailsModelData[dayIndex].temperature
            this.nightDetailsView.WeatherStatusLabel = this.nightDetailsModelData[dayIndex].description
            this.nightDetailsView.windSpeed = this.nightDetailsModelData[dayIndex].windSpeed
            this.nightDetailsView.humidity = this.nightDetailsModelData[dayIndex].humidity
            this.nightDetailsView.ufIndex = this.nightDetailsModelData[dayIndex].ufIndex
            this.nightDetailsView.cloudy = this.nightDetailsModelData[dayIndex].cloudy

            this.sunAndMoonDetailsView.moonDurationTime = this.moonAndSunDetailsModelData[dayIndex].moonDuration
            this.sunAndMoonDetailsView.moonRise = this.moonAndSunDetailsModelData[dayIndex].moonRise
            this.sunAndMoonDetailsView.moonSet = this.moonAndSunDetailsModelData[dayIndex].moonSet
            
            this.sunAndMoonDetailsView.sunDurationTime = this.moonAndSunDetailsModelData[dayIndex].sunDuration
            
            this.sunAndMoonDetailsView.sunRiseTime = this.moonAndSunDetailsModelData[dayIndex].sunRise
            this.sunAndMoonDetailsView.sunSetTime = this.moonAndSunDetailsModelData[dayIndex].sunSet
            
            this.airQualityDetailsView.AirQuality = this.airQualityModelData[dayIndex].value
            this.airQualityDetailsView.AirQualityEstimation = this.airQualityModelData[dayIndex].estimation
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dayDetailsArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let nightDetailsArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let dayDetailsView : ForecastDetailsView = {
        let view = ForecastDetailsView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.ViewLabel = "День"
        view.WeatherStatusLabel = "Ливни"
        view.DegreeValue = "13°"
        return view
    }()

    private let nightDetailsView : ForecastDetailsView = {
        let view = ForecastDetailsView(viewFrame: .zero)
        view.ViewLabel = "Ночь"
        view.WeatherStatusLabel = "Ливни"
        view.DegreeValue = "0°"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let sunAndMoonDetailsArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let airQualityDetailsArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private func setupViewAreas()
    {
        scrollViewContainer.addArrangedSubview(backButtonArea)
        scrollViewContainer.addArrangedSubview(cityLabelArea)
        scrollViewContainer.addArrangedSubview(daySelectorArea)
        scrollViewContainer.addArrangedSubview(dayDetailsArea)
        scrollViewContainer.addArrangedSubview(nightDetailsArea)
        scrollViewContainer.addArrangedSubview(sunAndMoonDetailsArea)
        scrollViewContainer.addArrangedSubview(airQualityDetailsArea)
        
        let constraints = [
            backButtonArea.heightAnchor.constraint(equalToConstant: 20 + 24),
            cityLabelArea.heightAnchor.constraint(equalToConstant: 22 + 15),
            daySelectorArea.heightAnchor.constraint(equalToConstant: 80),
            dayDetailsArea.heightAnchor.constraint(equalToConstant: 341 + 20),
            nightDetailsArea.heightAnchor.constraint(equalToConstant: 341 + 20),
            sunAndMoonDetailsArea.heightAnchor.constraint(equalToConstant: 160),
            airQualityDetailsArea.heightAnchor.constraint(equalToConstant: 160)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupDayAndNightDetailsView()
    {
        dayDetailsArea.addSubview(dayDetailsView)
        
        let dayDetailsConstraints = [
            dayDetailsView.bottomAnchor.constraint(equalTo: dayDetailsArea.bottomAnchor),
            dayDetailsView.leadingAnchor.constraint(equalTo: dayDetailsArea.leadingAnchor, constant: 16),
            dayDetailsView.trailingAnchor.constraint(equalTo: dayDetailsArea.trailingAnchor, constant: -16),
            dayDetailsView.heightAnchor.constraint(equalToConstant: 341)
        ]
        
        NSLayoutConstraint.activate(dayDetailsConstraints)
        
        nightDetailsArea.addSubview(nightDetailsView)
        
        let nightDetailsConstraints = [
            nightDetailsView.bottomAnchor.constraint(equalTo: nightDetailsArea.bottomAnchor),
            nightDetailsView.leadingAnchor.constraint(equalTo: nightDetailsArea.leadingAnchor, constant: 16),
            nightDetailsView.trailingAnchor.constraint(equalTo: nightDetailsArea.trailingAnchor, constant: -16),
            nightDetailsView.heightAnchor.constraint(equalToConstant: 341)
        ]
        
        NSLayoutConstraint.activate(nightDetailsConstraints)
    }
    
    private func setupDaySelectorView()
    {
        daySelectorArea.addSubview(daySelectorViewItem)
        let constraints = [
            daySelectorViewItem.leadingAnchor.constraint(equalTo: daySelectorArea.leadingAnchor, constant: 16),
            daySelectorViewItem.trailingAnchor.constraint(equalTo: daySelectorArea.trailingAnchor, constant: -16),
            daySelectorViewItem.centerYAnchor.constraint(equalTo: daySelectorArea.centerYAnchor),
            daySelectorViewItem.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupBackButton()
    {
        backButtonArea.addSubview(backButton)
        
        let constraints = [
            backButton.leadingAnchor.constraint(equalTo: backButtonArea.leadingAnchor, constant: 12),
            backButton.bottomAnchor.constraint(equalTo: backButtonArea.bottomAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 200),
            backButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    private func setupCityLabel()
    {
        cityLabelArea.addSubview(cityLabel)
        
        let constraints = [
            cityLabel.leadingAnchor.constraint(equalTo: cityLabelArea.leadingAnchor, constant: 16),
            cityLabel.bottomAnchor.constraint(equalTo: cityLabelArea.bottomAnchor),
            cityLabel.widthAnchor.constraint(equalToConstant: 155),
            cityLabel.heightAnchor.constraint(equalToConstant: 22)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    private let sunAndMoonDetailsView : SunAndMoonDetailsView = {
        let view = SunAndMoonDetailsView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupSunAndMoonDetails()
    {
        LayoutAssembler.fillAreaWithView(area: sunAndMoonDetailsArea, filler: sunAndMoonDetailsView)
    }
    
    private let airQualityDetailsView : AirQualityDetailsView = {
        let view = AirQualityDetailsView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupAirQualityDetails()
    {
        LayoutAssembler.fillAreaWithView(area: airQualityDetailsArea, filler: airQualityDetailsView)
    }
    
    private func setupLayout()
    {
        self.addSubview(scrollView)
        
        scrollView.addSubview(scrollViewContainer)

        setupScrollView()
        
        setupViewAreas()
        
        setupBackButton()
        
        setupCityLabel()
        
        setupDaySelectorView()
        
        setupDayAndNightDetailsView()
        
        setupSunAndMoonDetails()
        
        setupAirQualityDetails()
    }
    
    private func setupViews()
    {
        backgroundColor = .white
        
        setupLayout()
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for DaySummaryView")
    }
}
