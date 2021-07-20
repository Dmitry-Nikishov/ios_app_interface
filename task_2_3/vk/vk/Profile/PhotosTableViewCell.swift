//
//  PhotosTableViewCell.swift
//  vk
//
//  Created by Дмитрий Никишов on 11.07.2021.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    var navigationHandler : PhotoNavigationHandler?

    private var photoWidth : CGFloat = (UIScreen.main.bounds.width -
                                            3*ShortPhotoGaleryLayoutSettings.spacingBetweenImagesInShortGalery - 2*ShortPhotoGaleryLayoutSettings.contentViewOffset)/4
    
    private let titleLabelView : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.textColor = .black
        view.text = "Photos"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonView : UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: "arrow.right"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(goToGaleryClickedHandler), for: .touchUpInside)
        return view
    }()
    
    @objc private func goToGaleryClickedHandler() {
        guard let handler = navigationHandler else {
            return
        }
        
        handler()
    }
    
    private lazy var photosPreview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PhotoGaleryCollectionViewCell.self,
                      forCellWithReuseIdentifier: String(describing: PhotoGaleryCollectionViewCell.self))
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeGestureHandlerForView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeGestureHandlerForView()
        setupViews()
    }

    private func initializeGestureHandlerForView()
    {
        let tapGesture = UITapGestureRecognizer(target : self, action : #selector(goToGaleryClickedHandler))

        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGesture)
    }
    
    private func setupViews()
    {
        contentView.addSubview(titleLabelView)
        contentView.addSubview(buttonView)
        contentView.addSubview(photosPreview)
        
        let constraints = [
            titleLabelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ShortPhotoGaleryLayoutSettings.contentViewOffset),
            titleLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShortPhotoGaleryLayoutSettings.contentViewOffset),
            buttonView.centerYAnchor.constraint(equalTo: titleLabelView.centerYAnchor),
            buttonView.trailingAnchor.constraint(equalTo : contentView.trailingAnchor, constant: -ShortPhotoGaleryLayoutSettings.contentViewOffset),
            buttonView.heightAnchor.constraint(equalToConstant: 30),
            buttonView.widthAnchor.constraint(equalToConstant: 30),
            photosPreview.leadingAnchor.constraint(equalTo: titleLabelView.leadingAnchor),
            photosPreview.topAnchor.constraint(equalTo : titleLabelView.bottomAnchor, constant: ShortPhotoGaleryLayoutSettings.contentViewOffset),
            photosPreview.heightAnchor.constraint(equalToConstant : photoWidth*1.1),
            photosPreview.trailingAnchor.constraint(equalTo : contentView.trailingAnchor, constant: -ShortPhotoGaleryLayoutSettings.contentViewOffset),
            photosPreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ShortPhotoGaleryLayoutSettings.contentViewOffset)
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
                                                String(describing: PhotoGaleryCollectionViewCell.self),
                                              for: indexPath) as! PhotoGaleryCollectionViewCell
        
        cell.imageName = PhotoGaleryData.images[indexPath.row]
        
        return cell
    }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoWidth, height: photoWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ShortPhotoGaleryLayoutSettings.spacingBetweenImagesInShortGalery
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

