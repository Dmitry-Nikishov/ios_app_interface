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

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)

        tableView.register(ProfileTableHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: ProfileTableHeaderView.self))
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: String(describing: ProfileTableViewCell.self))
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))

        tableView.dataSource = self

        tableView.delegate = self
    }

}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self)) as! ProfileTableViewCell

                cell.cellData = Data.dataToDisplay[indexPath.section - 1]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self)) as! PhotosTableViewCell

            cell.navigationHandler = {
                let photosViewController = PhotosViewController()
                self.navigationController?.pushViewController(photosViewController, animated: true)
                self.navigationController?.navigationBar.isHidden = false
            }
            return cell
        }
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
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileTableHeaderView.self)) as? ProfileTableHeaderView else { return nil }
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
