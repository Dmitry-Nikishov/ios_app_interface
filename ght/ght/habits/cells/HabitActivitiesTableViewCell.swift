//
//  HabitActivitiesTableViewCell.swift
//  ght
//
//  Created by Дмитрий Никишов on 03.08.2021.
//

import UIKit

class HabitActivitiesTableViewCell: UITableViewCell {
    public var dateAsString : String? {
        didSet {
            guard let activityDateAsText = dateAsString else {
                return
            }
            
            activityDateLabel.text = activityDateAsText
        }
    }
        
    private let activityDateLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkMarkItem : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .systemPurple
        view.image = UIImage(systemName: "checkmark")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView()
    {
        contentView.addSubview(activityDateLabel)
        contentView.addSubview(checkMarkItem)
        
        let constraints = [
            activityDateLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            activityDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            activityDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            checkMarkItem.topAnchor.constraint(equalTo: activityDateLabel.topAnchor),
            checkMarkItem.bottomAnchor.constraint(equalTo: activityDateLabel.bottomAnchor),
            checkMarkItem.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            checkMarkItem.widthAnchor.constraint(equalToConstant: contentView.bounds.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}
