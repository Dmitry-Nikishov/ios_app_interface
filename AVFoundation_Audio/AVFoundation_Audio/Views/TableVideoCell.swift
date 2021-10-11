//
//  TableVideoCell.swift
//  AVFoundation_Audio
//
//  Created by Дмитрий Никишов on 11.10.2021.
//
import UIKit

class TableVideoCell: UITableViewCell {

    var videoDescription : String? {
        didSet {
            videoTitleView.text = videoDescription
        }
    }
        
    let videoTitleView : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "bla bla"
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
        contentView.addSubview(videoTitleView)
        
        let constraints = [
            videoTitleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            videoTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            videoTitleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
