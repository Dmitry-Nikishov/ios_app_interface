//
//  ProfileTableViewCell.swift
//  vk
//
//  Created by Дмитрий Никишов on 09.07.2021.
//

import UIKit

import StorageService

class ProfileTableViewCell: UITableViewCell {
    
    var cellData : Post? {
        didSet {
            authorView.text = cellData!.author
            postDescriptionView.text = cellData!.description
            likesView.text = "Likes: \(cellData!.likes)"
            viewsView.text = "Views: \(cellData!.views)"
        }
    }
    
    var cellImage : UIImage? {
        didSet {
            guard let image = cellImage else {
                return
            }
            
            self.postImageView.image = image
        }
    }
    
    let postImageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postDescriptionView : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    
    let authorView : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    let likesView : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewsView : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    
    private func setupViews()
    {
        contentView.addSubview(authorView)
        contentView.addSubview(postImageView)
        contentView.addSubview(postDescriptionView)
        contentView.addSubview(likesView)
        contentView.addSubview(viewsView)
        
        let constraints = [
            authorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            authorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            authorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            postImageView.topAnchor.constraint(equalTo: authorView.bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            postDescriptionView.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            postDescriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            postDescriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            likesView.topAnchor.constraint(equalTo: postDescriptionView.bottomAnchor, constant: 12),
            likesView.leadingAnchor.constraint(equalTo: postDescriptionView.leadingAnchor),
            likesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            viewsView.topAnchor.constraint(equalTo: likesView.topAnchor),
            viewsView.trailingAnchor.constraint(equalTo: postDescriptionView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
