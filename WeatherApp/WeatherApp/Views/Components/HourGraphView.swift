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
    func applyChartData(chartData : UiPerHourChartData)
    {
        hours = chartData.items.compactMap{$0.dayTime}
        let tempValues = chartData.items.compactMap{$0.temperature}
        let humidValues = chartData.items.compactMap{$0.humidity}

        var tempPoints: [ChartDataEntry] = []
        var humidPoints: [ChartDataEntry] = []

        for count in (0..<hours.count) {
            tempPoints.append(ChartDataEntry.init(x: Double(count), y: tempValues[count]))
            humidPoints.append(ChartDataEntry.init(x: Double(count), y: humidValues[count], icon: #imageLiteral(resourceName: "humidity")))
        }

        let temprSet = LineChartDataSet(entries: tempPoints, label: nil)
        temprSet.lineWidth = 0.3
        temprSet.circleRadius = 3
        temprSet.setColor(.systemBlue)
        temprSet.setCircleColor(.white)

        let humidSet = ScatterChartDataSet(entries: humidPoints, label: nil)
        
        temperatureChartView.data = LineChartData(dataSets: [temprSet])
        humidityChartView.data = ScatterChartData(dataSets: [humidSet])
    }
    
    private var hours = [String]()
    
    private lazy var temperatureChartView: LineChartView = {
        let view = LineChartView()
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.chartDescription?.enabled = false

        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.drawAxisLineEnabled = false

        view.xAxis.enabled = false
        view.rightAxis.enabled = false
        view.leftAxis.enabled = false
        view.drawBordersEnabled = false
        view.legend.form = .none
        view.isUserInteractionEnabled = false
        view.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        view.minOffset = 20

        return view
    }()

    private lazy var humidityChartView: ScatterChartView = {
        let view = ScatterChartView()
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.chartDescription?.enabled = false

        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.drawAxisLineEnabled = true
        view.xAxis.axisLineColor = .systemBlue
        
        let xAxisValue = view.xAxis
        xAxisValue.valueFormatter = self
        xAxisValue.labelPosition = .bottom
        xAxisValue.labelFont = UIFont.systemFont(ofSize: 10)

        view.rightAxis.enabled = false
        view.leftAxis.enabled = false
        view.drawBordersEnabled = false
        view.legend.form = .none
        view.isUserInteractionEnabled = false
        view.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        view.minOffset = 20

        return view
    }()
    
    private let chartsStackView : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 0
        return view
    }()
    
    private let temperatureChartArea : UIView = {
        let view = UIView()
        return view
    }()

    private let humidityChartArea : UIView = {
        let view = UIView()
        return view
    }()

    private func setupView()
    {
        LayoutAssembler.fillAreaWithView(area: self, filler: chartsStackView)
        chartsStackView.addArrangedSubview(temperatureChartArea)
        chartsStackView.addArrangedSubview(humidityChartArea)
        LayoutAssembler.fillAreaWithView(area: temperatureChartArea, filler: temperatureChartView)
        LayoutAssembler.fillAreaWithView(area: humidityChartArea, filler: humidityChartView)
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

extension HourGraphView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return hours[Int(value)]
    }
}
