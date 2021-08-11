//
//  HabitDetailsViewController.swift
//  ght
//
//  Created by Дмитрий Никишов on 01.08.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    var tableViewHeight: NSLayoutConstraint?
    
    public weak var dataRefresher : HabitDataReloadDelegate?
    
    public var controllerTitle : String? {
        didSet {
            guard let title = controllerTitle else {
                return
            }
            
            self.title = title
        }
    }
    
    public var habitColor : UIColor?
    
    public var habitDate : Date?
    
    public var trackedDates : [Date]?
    
    private let tableView : UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let editButton = UIBarButtonItem(title: "Править",
                        style: .plain,
                        target: self,
                        action: #selector(editHabitHandler))

        editButton.tintColor = .systemPurple
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationController?.navigationBar.tintColor = .systemPurple
        
        setupTable()
        setupView()
    }
    
    private func setupView()
    {
        view.addSubview(tableView)
        view.backgroundColor = .systemGray6
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        tableViewHeight = NSLayoutConstraint(item: tableView,
        attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
        multiplier: 0.0, constant: 250)
        tableViewHeight?.isActive = true
    }
    
    private func setupTable()
    {
        tableView.register(HabitActivitiesTableViewCell.self, forCellReuseIdentifier: String(describing: HabitActivitiesTableViewCell.self))

        tableView.dataSource = self

        tableView.delegate = self
    }

    @objc private func editHabitHandler()
    {
        let detailsViewEditController = HabitViewEditController()
        detailsViewEditController.controllerTitle = controllerTitle
        detailsViewEditController.originalHabitNameBeforeEditing = controllerTitle
        detailsViewEditController.habitColor = habitColor
        detailsViewEditController.habitDate = habitDate
        detailsViewEditController.dataRefresher = dataRefresher

        self.navigationController?.pushViewController(detailsViewEditController, animated: false)
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HabitActivitiesTableViewCell.self)) as! HabitActivitiesTableViewCell

        if let dates = trackedDates {
            cell.dateAsString = DateToFromStringConverter.toStringWithCalendarData(date: dates[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dates = trackedDates {
            return dates.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
             indexPathForSelectedRow == indexPath {
             tableView.deselectRow(at: indexPath, animated: false)
             return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0 {
            return "Активности"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHeight?.constant = tableView.contentSize.height
        tableView.layoutIfNeeded()
    }
}


