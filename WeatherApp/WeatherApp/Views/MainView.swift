//
//  MainView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 21.12.2021.
//

import UIKit

class MainView : UIView {
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
    
    private let navigationArea : UIView = {
        let view = NavigationView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let perDayHeaderAreaView : UIView = {
        let view = PerDayHeaderAreaView(viewFrame: .zero)
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
    
    private let dayDisplayView : UIView = {
        let view = DayDisplayView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gotoDetailed24View : UIView = {
        let view = GoToDetailed24View(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let perHourDataView : UIView = {
        let view = PerHourDataView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let perDayAreaView : UIView = {
        let view = PerDayAreaView(viewFrame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
            
    private func setupViews() {
        self.addSubview(scrollView)
        
        scrollView.addSubview(scrollViewContainer)

        setupScrollView()
        
        setupViewAreas()
        
        LayoutAssembler.fillAreaWithView(area: headerArea, filler: navigationArea)

        LayoutAssembler.fillAreaWithView(area: dayDisplayArea, filler: dayDisplayView)
        
        LayoutAssembler.fillAreaWithView(area: detailedFor24Area, filler: gotoDetailed24View)
        
        LayoutAssembler.fillAreaWithView(area: perHourArea, filler: perHourDataView)
        
        LayoutAssembler.fillAreaWithView(area: perDayHeaderArea, filler: perDayHeaderAreaView)
        
        LayoutAssembler.fillAreaWithView(area: perDayArea, filler: perDayAreaView)
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for MainView")
    }
}
