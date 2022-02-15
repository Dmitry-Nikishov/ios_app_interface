//
//  FolderViewController.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import UIKit

class FolderViewController: UIViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate,
                      FolderCollectionDelegate {
    
    func updateCollectionView() {
        updateUiWithFolderContent()
    }
    
    public var currentSettingsViewSetup : SettingsViewSetup?
    
    private var folderItems : [URL] = []
    
    private var safeArea : UILayoutGuide!
    
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    private let scrollView : UIScrollView = {
            let view = UIScrollView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.keyboardDismissMode = .onDrag
            return view
        }()
        
    private let contentView : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Содержимое папки Documents"
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 80.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let folderItemsCollection : UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .vertical

      let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
        
    func setupViews(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(folderItemsCollection)
    
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            folderItemsCollection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            folderItemsCollection.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            folderItemsCollection.heightAnchor.constraint(equalToConstant: view.bounds.height*0.7),
            folderItemsCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
    
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupScrollView()
    {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let constraints = [
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    private func updateUiWithFolderContent()
    {
        utilityQueue.async {
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            if let url = documentsUrl {
                do {
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
                    
                    self.folderItems = directoryContents
                    
                    self.sortFolderUrls()
                    
                    DispatchQueue.main.async {
                        self.folderItemsCollection.reloadData()
                    }
                } catch {}
            }
        }
    }
        
    private func setupNavigationBar()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Photo",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(addPhotoHandler))
    }
    
    @objc private func addPhotoHandler()
    {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        dismiss(animated: true)
        
        updateUiWithFolderContent()
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func setupCollectionView()
    {
        folderItemsCollection.register(FolderItemCollectionViewCell.self,
                      forCellWithReuseIdentifier: String(describing: FolderItemCollectionViewCell.self))
        folderItemsCollection.dataSource = self
        folderItemsCollection.delegate = self
    }
    
    private func sortFolderUrls()
    {
        if let setup = self.currentSettingsViewSetup {
            if setup.isSortingEnabled {
                folderItems.sort {
                    let compareResult = $0.absoluteString.compare($1.absoluteString, options: .numeric)
                    if setup.isAscendingMode {
                        return compareResult == .orderedAscending
                    } else {
                        return compareResult == .orderedDescending
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        safeArea = view.layoutMarginsGuide
        
        setupScrollView()
        setupViews()
        setupNavigationBar()
        setupCollectionView()
        
        updateUiWithFolderContent()
    }
    
    public func applySettingsViewSetup(setup : SettingsViewSetup?)
    {
        self.currentSettingsViewSetup = setup
        self.sortFolderUrls()
        self.folderItemsCollection.reloadData()
    }
}

extension FolderViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.folderItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        folderItemsCollection.dequeueReusableCell(withReuseIdentifier:
                                                String(describing: FolderItemCollectionViewCell.self),
                                              for: indexPath) as! FolderItemCollectionViewCell
            
        cell.content = self.folderItems[indexPath.section]
        cell.collectionDelegate = self

        return cell
    }
}

extension FolderViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.folderItemsCollection.bounds.width,
                          height: self.folderItemsCollection.bounds.height/15)
    }
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    }
}

