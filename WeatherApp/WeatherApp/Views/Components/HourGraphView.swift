//
//  HourGraphView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 10.01.2022.
//

import UIKit
import Charts

class HourGraphView : UIView
{
    private let chartView: LineChartView = {
            let view = LineChartView()
            view.backgroundColor = .white
            view.toAutoLayout()
            return view
        }()
    
    private func setupView()
    {
        backgroundColor = .blue
    }
    
    init(viewFrame : CGRect)
    {
        super.init(frame: viewFrame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented for HourGraphView")
    }
}
