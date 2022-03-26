//
//  MainView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class MainView : UIView {
    public var menuClickHandler : UiViewClickHandler?
    public var perDayClickHandler : UiViewClickHandler?
    public var per24ClickHandler : UiViewClickHandler?
    public var addLocationClickHandler : UiViewClickHandler?
    public var updateWeatherDataRequestHandler : UiUpdateWithWeatherDataRequestHandler?
     
    func addNewCity(cityName : String)
    {
        var geoPoints = navigationArea.currentGeoPoints
        if !geoPoints.contains(cityName) {
            geoPoints.append(cityName)
            navigationArea.currentGeoPoints = geoPoints
        }
    }
    
    func applyModelData(dataForUi : [UiPerDayCollectionDataItem]) {
        perDayAreaView.updateWithModelData(data: dataForUi)
    }
    
    func applyModelData(dataForUi : [UiPerHourCollectionDataItem]) {
        perHourDataView.updateWithModelData(data: dataForUi)
    }
    
    func applyModelData(dataForUi : UiWeatherDataOneDay) {
        dayDisplayView.sunriseTime = dataForUi.sunriseTime
        dayDisplayView.sunsetTime = dataForUi.sunsetTime
        dayDisplayView.calendarTime = dataForUi.dayTimePeriod
        dayDisplayView.feelsLikeTemperature = dataForUi.feelsLikeTemperature
        dayDisplayView.currentTemperature = dataForUi.temperature
        dayDisplayView.forecastDescription = dataForUi.description
        dayDisplayView.clouds = dataForUi.clouds
        dayDisplayView.wind = dataForUi.windSpeed
        dayDisplayView.percipitation = dataForUi.humidity
    }
    
    var currentGeoPoint : String {
        get {
            return navigationArea.currentGeoPoint
        }
    }
    
    var existingGeoPoints : Int {
        get {
            return navigationArea.currentGeoPoints.count
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
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
    
    @objc
    private func leftSwipeHandler()
    {
        navigationArea.handleLeftSwipe()
    }

    @objc
    private func rightSwipeHandler()
    {
        navigationArea.handleRightSwipe()
    }

    private lazy var navigationArea : NavigationView = {
        let view = NavigationView(viewFrame: .zero)
        view.menuClickHandler = { [weak self] in
            self?.menuClickHandler?()
        }
        view.addLocationClickHandler = { [weak self] in
            self?.addLocationClickHandler?()
        }
        
        view.updateWeatherDataRequestHandler = { [weak self] poiName in
            self?.updateWeatherDataRequestHandler?(poiName)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        let leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        leftSwipe.addTarget(self, action: #selector(leftSwipeHandler))

        let rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = .right
        rightSwipe.addTarget(self, action: #selector(rightSwipeHandler))

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        return view
    }()
            
    private let headerArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let dayDisplayArea : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let perHourArea : UIView = {
        let view = UIView()
        return view
    }()

    private let perDayArea : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    private let detailedFor24Area : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var perDayHeaderAreaView : PerDayHeaderAreaView = {
        let view = PerDayHeaderAreaView(viewFrame: .zero)
        view.perDayDetailsHandler = { [weak self] in
            self?.perDayClickHandler?()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let perDayHeaderArea : UIView = {
        let view = UIView()
        return view
    }()
        
    private func setupViewAreas()
    {
        scrollViewContainer.addArrangedSubview(headerArea)
        scrollViewContainer.addArrangedSubview(dayDisplayArea)
        scrollViewContainer.addArrangedSubview(detailedFor24Area)
        scrollViewContainer.addArrangedSubview(perHourArea)
        scrollViewContainer.addArrangedSubview(perDayHeaderArea)
        scrollViewContainer.addArrangedSubview(perDayArea)

        let constraints = [
            headerArea.heightAnchor.constraint(equalToConstant: 55+37),
            dayDisplayArea.heightAnchor.constraint(equalToConstant: 212),
            detailedFor24Area.heightAnchor.constraint(equalToConstant: 40),
            perHourArea.heightAnchor.constraint(equalToConstant: 83),
            perDayHeaderArea.heightAnchor.constraint(equalToConstant: 40),
            perDayArea.heightAnchor.constraint(equalToConstant: 540)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    private let dayDisplayView : DayDisplayView = {
        let view = DayDisplayView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gotoDetailed24View : UIView = {
        let view = GoToDetailed24View(viewFrame: .zero)
        view.details24Handler = { [weak self] in
            self?.per24ClickHandler?()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let perHourDataView : PerHourDataView = {
        let view = PerHourDataView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let perDayAreaView : PerDayAreaView = {
        let view = PerDayAreaView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc
    private func plusImageViewClickHandler()
    {
        addLocationClickHandler?()
    }
    
    private lazy var plusImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "plus")
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(plusImageViewClickHandler))
        view.addGestureRecognizer(tap)
        
        return view
    }()
            
    private func setupViewsForExistingGeoPoints(initialGeoPoints : [String])
    {
        setupViewAreas()
        
        LayoutAssembler.fillAreaWithView(area: headerArea, filler: navigationArea)

        LayoutAssembler.fillAreaWithView(area: dayDisplayArea, filler: dayDisplayView)
        
        LayoutAssembler.fillAreaWithView(area: detailedFor24Area, filler: gotoDetailed24View)
        
        LayoutAssembler.fillAreaWithView(area: perHourArea, filler: perHourDataView)
        
        LayoutAssembler.fillAreaWithView(area: perDayHeaderArea, filler: perDayHeaderAreaView)
        
        LayoutAssembler.fillAreaWithView(area: perDayArea, filler: perDayAreaView)
        
        navigationArea.currentGeoPoints = initialGeoPoints
    }
    
    private func setupViewsForNonExistingGeoPoints()
    {
        scrollViewContainer.addArrangedSubview(headerArea)
        scrollViewContainer.addArrangedSubview(plusImageView)
        
        let constraints = [
            headerArea.heightAnchor.constraint(equalToConstant: 55+37),
            plusImageView.heightAnchor.constraint(equalToConstant: self.bounds.height - 55 - 37 - 100)
        ]
        NSLayoutConstraint.activate(constraints)
                
        LayoutAssembler.fillAreaWithView(area: headerArea, filler: navigationArea)
    }
    
    private func setupViews(geoItems : [String]) {
        self.addSubview(scrollView)
        
        scrollView.addSubview(scrollViewContainer)

        setupScrollView()
        
        if geoItems.isEmpty {
            setupViewsForNonExistingGeoPoints()
        } else {
            setupViewsForExistingGeoPoints(initialGeoPoints: geoItems)
        }
    }
    
    init(viewFrame : CGRect, geoPoints : [String]) {
        super.init(frame: viewFrame)
        backgroundColor = .white
        setupViews(geoItems : geoPoints)
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for MainView")
    }
}
