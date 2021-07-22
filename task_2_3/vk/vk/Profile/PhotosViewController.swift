//
//  PhotosViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 11.07.2021.
//

import UIKit

class PhotosViewController: UIViewController {
    private var photoWidth : CGFloat = 0
    
    private lazy var photoGalleryCollection : UICollectionView = {
        var layout = UICollectionViewFlowLayout()

        let item = UICollectionView(frame: .zero, collectionViewLayout: layout)
        item.register(
            PhotoGalleryCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: PhotoGalleryCollectionViewCell.self)
        )

        item.dataSource = self
        item.delegate = self
        item.backgroundColor = .white

        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoWidth = (
            view.bounds.width -
            2 * PhotoGalleryLayoutSettings.spacingBetweenImagesInShortGallery -
            2 * PhotoGalleryLayoutSettings.contentViewOffset) / 3
        
        setupViews()
    }

    private func setupViews()
    {
        self.title = "Photo Galery"
        view.addSubview(photoGalleryCollection)
        
        let constraints = [
            photoGalleryCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PhotoGalleryLayoutSettings.contentViewOffset),
            
            photoGalleryCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PhotoGalleryLayoutSettings.contentViewOffset),
            
            photoGalleryCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -PhotoGalleryLayoutSettings.contentViewOffset),
            
            photoGalleryCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -PhotoGalleryLayoutSettings.contentViewOffset)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}


extension PhotosViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoGalleryData.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            photoGalleryCollection.dequeueReusableCell(
                withReuseIdentifier: String(describing: PhotoGalleryCollectionViewCell.self),
                for: indexPath) as! PhotoGalleryCollectionViewCell

        cell.imageName = PhotoGalleryData.images[indexPath.row]

        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoWidth, height: photoWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PhotoGalleryLayoutSettings.spacingBetweenImagesInShortGallery
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

