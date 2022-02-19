//
//  HourSummaryTableDetailsView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 10.01.2022.
//

import UIKit

class HourSummaryTableDetailsView : UIView
{
    private var modelData = UiPerHourDetails()
    
    func applyDataForView(uiData : UiPerHourDetails)
    {
        modelData = uiData
        tableView.reloadData()
    }
    
    private let tableView : UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupTableView()
    {
        tableView.register(HourDetailsTableCell.self, forCellReuseIdentifier: String(describing: HourDetailsTableCell.self))
        
        tableView.dataSource = self

        tableView.delegate = self
    }
    
    private func setupView()
    {
        backgroundColor = .red
        
        setupTableView()
        
        LayoutAssembler.fillAreaWithView(area: self, filler: tableView)
    }
    
    init(viewFrame : CGRect)
    {
        super.init(frame: viewFrame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented for HourSummaryTableDetailsView")
    }
}

extension HourSummaryTableDetailsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HourDetailsTableCell.self)) as! HourDetailsTableCell

        let dataItem = modelData.items[indexPath.section]
        cell.calendarDate = dataItem.calendarDate
        cell.dayTime = dataItem.dayTime
        cell.temperature = dataItem.temperature
        cell.temperatureDescription = dataItem.temperatureDescription
        cell.windDescription = dataItem.windDescription
        cell.humidity = dataItem.humidity
        cell.cloudy = dataItem.cloudy

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelData.items.count
    }
}

extension HourSummaryTableDetailsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
             indexPathForSelectedRow == indexPath {
             tableView.deselectRow(at: indexPath, animated: false)
             return nil
        }
        return indexPath
    }
}
