//
//  BookmarkedViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 01.12.2021.
//

import UIKit
import StorageService
import CoreData

class BookmarkedViewController : UIViewController {
    private var isInitiallyLoaded: Bool = false
    
    private let stack: CoreDataStack
    
    private lazy var fetchResultsController: NSFetchedResultsController<PostDb> = {
                
        let request: NSFetchRequest<PostDb> = PostDb.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "author", ascending: false)]
       let controller = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: stack.getViewContext(),
        sectionNameKeyPath: nil,
        cacheName: nil
       )
        controller.delegate = self
        return controller
    }()

    private let tableView : UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isInitiallyLoaded {
            isInitiallyLoaded = true
            stack.getViewContext().perform {
                do {
                    try self.fetchResultsController.performFetch()
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
    }

    private func syncWithDb()
    {
        stack.getViewContext().perform {
            self.fetchResultsController.fetchRequest.predicate = nil
            do {
                try self.fetchResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    private func syncWithDbFilteredByAuthor(author : String)
    {
        stack.getViewContext().perform {
            let predicate = NSPredicate(format: "author == %@", author)
            self.fetchResultsController.fetchRequest.predicate = predicate
            do {
                try self.fetchResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

extension BookmarkedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self)) as! ProfileTableViewCell

        let postItem = fetchResultsController.object(at: indexPath)
        let cellData = DbToFromDataConverter.toModel(post:postItem)
        cell.cellData = cellData
        cell.cellImage = UIImage(named: cellData.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects?.count ?? 0
    }
}

extension BookmarkedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
            guard let this = self else { return }
            
            let postToDelete = this.fetchResultsController.object(at: indexPath)
            
            this.stack.removeFromViewContext(post: postToDelete)
            
            success(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
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

extension BookmarkedViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
            case .delete:
                guard let indexPath = indexPath else { fallthrough }

                tableView.deleteRows(at: [indexPath], with: .automatic)
            case .insert:
                guard let newIndexPath = newIndexPath else { fallthrough }
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .move:
                guard
                    let indexPath = indexPath,
                    let newIndexPath = newIndexPath
                else { fallthrough }
                
                tableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { fallthrough }
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
            @unknown default:
                fatalError()
        }
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.endUpdates()
    }
}
