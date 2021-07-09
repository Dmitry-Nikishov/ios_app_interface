//
//  ProfileViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 08.07.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    private let tableView : UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cellID = "cellID"
    private let headerID = "headerViewID"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    
    private func setupTableView() {
        view.addSubview(tableView)

        tableView.register(ProfileTableHeaderView.self, forHeaderFooterViewReuseIdentifier: headerID)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: cellID)

        tableView.dataSource = self

        tableView.delegate = self
    }

}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ProfileTableViewCell
        if indexPath.section != 0 {
            cell.cellData = Data.dataToDisplay[indexPath.section - 1]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Data.dataToDisplay.count + 1
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? ProfileTableHeaderView else { return nil }
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        } else {
            return 0
        }
    }
}
