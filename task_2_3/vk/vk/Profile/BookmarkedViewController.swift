//
//  BookmarkedViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 01.12.2021.
//

import UIKit
import StorageService

class BookmarkedViewController : UIViewController {
    private let stack: CoreDataStack
    
    private let tableView : UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var dbData : [PostDb] = []

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: String(describing: ProfileTableViewCell.self))

        tableView.dataSource = self

        tableView.delegate = self
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

    @objc
    private func addFilterHandler()
    {
        var inputTextField: UITextField?;
        let promptAlert = UIAlertController(title: "Filter bookmarked items",
                                               message: "Enter author's name",
                                               preferredStyle: UIAlertController.Style.alert);
    
        promptAlert.addAction(UIAlertAction(title: "Apply",
                                            style: UIAlertAction.Style.default, handler: { [weak self] (action) -> Void in
            guard let this = self else {return}
            
            let filterCriteria = (inputTextField?.text) ?? "";
        
            this.syncWithDbFilteredByAuthor(author: filterCriteria)
        }));
        
        promptAlert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "author's name"
            textField.isSecureTextEntry = false
            inputTextField = textField
        });
    
        self.present(promptAlert, animated: true, completion: nil);
    }
    
    @objc
    private func removeFilterHandler()
    {
        self.syncWithDb()
    }
    
    private func setupFilterButtons()
    {
        let addFilter = UIBarButtonItem(title: "Filter",
                                        style: .plain,
                                        target: self,
                                        action: #selector(addFilterHandler))
        
        let removeFilter = UIBarButtonItem(title: "Remove Filter",
                                           style: .plain,
                                           target: self,
                                           action: #selector(removeFilterHandler))

        navigationItem.setLeftBarButton(addFilter, animated: false)
        navigationItem.setRightBarButton(removeFilter, animated: false)
    }
    
    init(stack : CoreDataStack)
    {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupConstraints()
        setupFilterButtons()
    }
    
    func syncWithDb()
    {
        self.dbData = self.stack.fetchDbPosts()
        self.tableView.reloadData()
    }
    
    func syncWithDbFilteredByAuthor(author : String)
    {
        self.dbData = self.stack.fetchDbPostsByAuthor(author: author)
        self.tableView.reloadData()
    }
}

extension BookmarkedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self)) as! ProfileTableViewCell

        let cellData = DbToFromDataConverter.toModel(post: dbData[indexPath.section])
        cell.cellData = cellData
        cell.cellImage = UIImage(named: cellData.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dbData.count
    }
}

extension BookmarkedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
            guard let this = self else { return }
            
            let postToDelete = this.dbData.remove(at: indexPath.section)
            this.tableView.performBatchUpdates {
                this.tableView.deleteSections([indexPath.section], with: .automatic)
            } completion: { (_) in
                this.stack.remove(post: postToDelete)
            }
            
            success(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
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
