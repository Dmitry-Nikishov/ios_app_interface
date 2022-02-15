//
//  FolderItemCollectionViewCell.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 18.11.2021.
//

import UIKit

class FolderItemCollectionViewCell: UICollectionViewCell {
    private let itemLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 16.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.textAlignment = .center
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private lazy var deleteButton : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.setTitle("Удалить", for: .normal)
        view.titleLabel?.textColor = .white
        
        view.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return view
    }()

    @objc
    private func deleteButtonPressed()
    {
        if let urlToDelete = contentUrl {
            try? FileManager.default.removeItem(at : urlToDelete)
            collectionDelegate?.updateCollectionView()
        }
        
        setupInitialView()
    }
    
    private var contentUrl : URL?
    
    public var content : URL? {
        set(newValue) {
            contentUrl = newValue
            itemLabel.text = newValue?.lastPathComponent
        }
        
        get {
            return contentUrl
        }
    }
    
    public var collectionDelegate : FolderCollectionDelegate?
    
    private var currentConstraints : [NSLayoutConstraint] = []
    
    private func setupViewWithDeleteButton()
    {
        if !currentConstraints.isEmpty {
            NSLayoutConstraint.deactivate(currentConstraints)
        }
        
        deleteButton.alpha = 1
        deleteButton.isUserInteractionEnabled = true

        let constraints = [
            itemLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.8),
            itemLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: itemLabel.trailingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
        
        self.currentConstraints = constraints
    }
    
    private func setupInitialView() {
        if !currentConstraints.isEmpty {
            NSLayoutConstraint.deactivate(currentConstraints)
        }

        deleteButton.alpha = 0
        deleteButton.isUserInteractionEnabled = false
        
        let constraints = [
            itemLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
        
        self.currentConstraints = constraints
    }
    
    @objc
    private func handleSwipeGesture()
    {
        setupViewWithDeleteButton()
    }
    
    private func setupGestureRecognizer()
    {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .left
        recognizer.addTarget(self, action: #selector(handleSwipeGesture))
        contentView.addGestureRecognizer(recognizer)
    }

    private func addSubItems()
    {
        contentView.addSubview(itemLabel)
        contentView.addSubview(deleteButton)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubItems()
        
        setupGestureRecognizer()
        setupInitialView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

