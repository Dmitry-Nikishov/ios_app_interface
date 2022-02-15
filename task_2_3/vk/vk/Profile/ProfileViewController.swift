//
//  ProfileViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 08.07.2021.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController, Coordinating {
    weak var coordinator: Coordinator?
    
    private let stack: CoreDataStack
    
    private var statusModel : UserStatusModel
    
    private var user : User?
    private let userService : UserService = TestUserService()
         
    public func getControllerUserService() -> UserService {
        return userService
    }
    
    public func setUser(user : User) {
        self.user = user
    }
    
    private let tableView : UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var processedImages : [UIImage?]
    
    private var imageProcessor : AsyncImageProcessor? = nil
    
    init(statusModel : UserStatusModel,
         stack: CoreDataStack) {
        self.stack = stack
        self.statusModel = statusModel
        self.processedImages = Array(repeating: nil, count: StorageData.dataToDisplay.count)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupConstraints()
    }
        
    private func processImages() {
        self.imageProcessor = AsyncImageProcessor(posts: StorageData.dataToDisplay,
                                                  completion: {
                                                        self.processedImages = $0
                                                        DispatchQueue.main.async {
                                                            self.tableView.reloadData()
                                                        }
                                                    }
                                                )

        self.imageProcessor?.start()
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
        processImages()
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

                cell.cellData = StorageData.dataToDisplay[indexPath.section - 1]
                cell.cellImage = self.processedImages[indexPath.section - 1]
                cell.bookmarkHandler = { [weak self] postData in
                    guard let this = self else { return }
                    this.stack.createNewPostViewContext(post: postData)
                }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self)) as! PhotosTableViewCell
            cell.coordinator = self.coordinator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return StorageData.dataToDisplay.count + 1
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileTableHeaderView.self)) as? ProfileTableHeaderView else { return nil }
            
            headerView.user = self.user
            headerView.profileControllerView = view
            headerView.profileController = self
            headerView.statusModel = self.statusModel
            
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

extension ProfileViewController : ProfileTableHeaderViewDelegate
{
    public func showBlackoutView()
    {
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }
    
    public func closeBlackoutView()
    {
        tableView.isScrollEnabled = true
        tableView.allowsSelection = true
    }
}
