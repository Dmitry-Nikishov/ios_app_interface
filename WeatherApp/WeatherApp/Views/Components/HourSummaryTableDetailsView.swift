//
//  HourSummaryTableDetailsView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 10.01.2022.
//

import UIKit

class HourSummaryTableDetailsView : UIView
{
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
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
