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
    
    private var viewConstraints : [NSLayoutConstraint] = []
    
    private lazy var blackoutView : UIView = {
        let view = UIView(frame: self.view.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.opacity = 0
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
        tableView.addSubview(blackoutView)
        
        view.addSubview(tableView)

        tableView.register(ProfileTableHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: ProfileTableHeaderView.self))
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: String(describing: ProfileTableViewCell.self))
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))

        tableView.dataSource = self

        tableView.delegate = self
    }

    public func showBlackoutView()
    {
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            self.blackoutView.layer.opacity = 0.5
            self.tableView.layer.opacity = 1
            self.tableView.bringSubviewToFront(self.blackoutView)
        }
        
        animator.startAnimation()
        
        blackoutView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
    }
    
    public func closeBlackoutView()
    {
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            self.blackoutView.layer.opacity = 0
            self.tableView.sendSubviewToBack(self.blackoutView)
        }
        
        animator.startAnimation()
        
        blackoutView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
        
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
            
            headerView.profileControllerView = view
            headerView.profileController = self
            
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

             if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
                 indexPathForSelectedRow == indexPath {
                 tableView.deselectRow(at: indexPath, animated: false)
                 return nil
             }
             return indexPath
         }
}
