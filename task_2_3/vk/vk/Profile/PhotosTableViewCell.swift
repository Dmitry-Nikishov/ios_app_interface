//
//  PhotosTableViewCell.swift
//  vk
//
//  Created by Дмитрий Никишов on 11.07.2021.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    var navigationHandler : PhotoNavigationHandler?

    private lazy var goToGalleryHandler : UiViewClickHandler = { [weak self] in
        guard let self = self else {
            return
        }
        
        guard let handler = self.navigationHandler else {
            return
        }
        
        handler()
    }
    
    private var photoWidth : CGFloat = (
        UIScreen.main.bounds.width -
        3 * ShortPhotoGalleryLayoutSettings.spacingBetweenImagesInShortGallery -
        2 * ShortPhotoGalleryLayoutSettings.contentViewOffset) / 4
    
    private let titleLabelView : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.textColor = .black
        view.text = "Photos"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var galleryButton : CustomButton = {
        let button = CustomButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.right"), for: .normal)
        return button
    }()
    
    @objc private func goToGalleryClickedHandler() {
        self.goToGalleryHandler()
    }
    
    private lazy var photosPreview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PhotoGalleryCollectionViewCell.self,
                      forCellWithReuseIdentifier: String(describing: PhotoGalleryCollectionViewCell.self))
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private func initializeInternals()
    {
        initializeGestureHandlerForView()
        setupViews()
        setupClickHandler()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeInternals()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeInternals()
    }

    private func initializeGestureHandlerForView()
    {
        let tapGesture = UITapGestureRecognizer(target : self,
                                                action : #selector(goToGalleryClickedHandler))

        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGesture)
    }
    
    private func setupClickHandler()
    {
        galleryButton.clickHandler = goToGalleryHandler
    }
        
    private func setupViews()
    {
        contentView.addSubview(titleLabelView)
        contentView.addSubview(galleryButton)
        contentView.addSubview(photosPreview)
        
        let constraints = [
            titleLabelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ShortPhotoGalleryLayoutSettings.contentViewOffset),
            titleLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShortPhotoGalleryLayoutSettings.contentViewOffset),
            galleryButton.centerYAnchor.constraint(equalTo: titleLabelView.centerYAnchor),
            galleryButton.trailingAnchor.constraint(equalTo : contentView.trailingAnchor, constant: -ShortPhotoGalleryLayoutSettings.contentViewOffset),
            galleryButton.heightAnchor.constraint(equalToConstant: 30),
            galleryButton.widthAnchor.constraint(equalToConstant: 30),
            photosPreview.leadingAnchor.constraint(equalTo: titleLabelView.leadingAnchor),
            photosPreview.topAnchor.constraint(equalTo : titleLabelView.bottomAnchor, constant: ShortPhotoGalleryLayoutSettings.contentViewOffset),
            photosPreview.heightAnchor.constraint(equalToConstant : photoWidth*1.1),
            photosPreview.trailingAnchor.constraint(equalTo : contentView.trailingAnchor, constant: -ShortPhotoGalleryLayoutSettings.contentViewOffset),
            photosPreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ShortPhotoGalleryLayoutSettings.contentViewOffset)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}


extension PhotosTableViewCell : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            photosPreview.dequeueReusableCell(withReuseIdentifier:
                                                String(describing: PhotoGalleryCollectionViewCell.self),
                                              for: indexPath) as! PhotoGalleryCollectionViewCell
        
        cell.imageName = PhotoGalleryData.images[indexPath.row]
        
        return cell
    }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoWidth, height: photoWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ShortPhotoGalleryLayoutSettings.spacingBetweenImagesInShortGallery
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

