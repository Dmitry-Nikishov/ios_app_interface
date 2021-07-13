//
//  PhotosViewController.swift
//  vk
//
//  Created by Дмитрий Никишов on 11.07.2021.
//

import UIKit

class PhotosViewController: UIViewController {
    private var photoWidth : CGFloat = (UIScreen.main.bounds.width -
                                            2*PhotoGaleryLayoutSettings.spacingBetweenImagesInShortGalery - 2*PhotoGaleryLayoutSettings.contentViewOffset)/3

    private lazy var photoGalleryCollection : UICollectionView = {
        var layout = UICollectionViewFlowLayout()

        let item = UICollectionView(frame: .zero, collectionViewLayout: layout)
        item.register(PhotoGaleryCollectionViewCell.self,
                      forCellWithReuseIdentifier: String(describing: PhotoGaleryCollectionViewCell.self))

        item.dataSource = self
        item.delegate = self
        item.backgroundColor = .white

        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews()
    {
        self.title = "Photo Galery"
        view.addSubview(photoGalleryCollection)
        
        let constraints = [
            photoGalleryCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PhotoGaleryLayoutSettings.contentViewOffset),
            
            photoGalleryCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PhotoGaleryLayoutSettings.contentViewOffset),
            
            photoGalleryCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -PhotoGaleryLayoutSettings.contentViewOffset),
            
            photoGalleryCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -PhotoGaleryLayoutSettings.contentViewOffset)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}


extension PhotosViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoGaleryData.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            photoGalleryCollection.dequeueReusableCell(withReuseIdentifier:
                                                String(describing: PhotoGaleryCollectionViewCell.self),
                                              for: indexPath) as! PhotoGaleryCollectionViewCell

        cell.imageName = PhotoGaleryData.images[indexPath.row]

        return cell

    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoWidth, height: photoWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PhotoGaleryLayoutSettings.spacingBetweenImagesInShortGalery
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

