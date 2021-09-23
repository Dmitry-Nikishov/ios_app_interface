//
//  PhotoGaleryShortCollectionViewCell.swift
//  vk
//
//  Created by Дмитрий Никишов on 11.07.2021.
//

import UIKit

class PhotoGalleryCollectionViewCell: UICollectionViewCell {
    var imageName : String? {
        didSet {
            if let img = imageName {
                photoArea.image = UIImage(named: img)
            }
        }
    }

    var photoImage : UIImage? {
        didSet {
            if let photo = photoImage {
                photoArea.image = photo
            }
        }
    }

    private let photoArea : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(photoArea)
        
        let constraints = [
            photoArea.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoArea.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoArea.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoArea.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
