//
//  ProgressCollectionViewCell.swift
//  ght
//
//  Created by Дмитрий Никишов on 31.07.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    public var currentProgress : Float? {
        didSet {
            guard let progressValue = currentProgress else {
                return
            }
            
            progressBarView.progress = progressValue
            percentageLabel.text = String(format: "%d%%", Int(progressValue*100))
        }
    }
    
    private let motivationLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Все получится!"
        view.textColor = .systemGray
        view.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    private let percentageLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .systemGray
        view.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        return view
    }()
    
    private let progressBarView : UIProgressView = {
        let view = UIProgressView()
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
    
    private func setupViews()
    {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(motivationLabel)
        contentView.addSubview(progressBarView)
        contentView.addSubview(percentageLabel)
        
        let constraints = [
            motivationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: HabitsCollectionLayoutSettings.progressCollectionViewContentOffset/2),
            motivationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HabitsCollectionLayoutSettings.progressCollectionViewContentOffset),

            progressBarView.leadingAnchor.constraint(equalTo: motivationLabel.leadingAnchor),
            progressBarView.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: HabitsCollectionLayoutSettings.progressCollectionViewContentOffset*1.5),
            progressBarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                      constant: -HabitsCollectionLayoutSettings.progressCollectionViewContentOffset),

            percentageLabel.topAnchor.constraint(equalTo: motivationLabel.topAnchor),
            percentageLabel.trailingAnchor.constraint(equalTo: progressBarView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
