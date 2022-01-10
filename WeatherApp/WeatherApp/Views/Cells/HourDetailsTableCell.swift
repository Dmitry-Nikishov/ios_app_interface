//
//  HourDetailsTableCell.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 10.01.2022.
//

import UIKit

class HourDetailsTableCell: UITableViewCell {
    private let dateLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.text = "пт 16/04"
        return view
    }()
    
    private let timeLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "12:00"
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return view
    }()
    
    private let degreeLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.text = "12°"
        return view
    }()
    
    private let row0ImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "moon")
        return view
    }()

    private let row1ImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "wind-1")
        return view
    }()

    private let row2ImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "percipitation")
        return view
    }()

    private let row3ImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cloud")
        return view
    }()
    
    private let row0Label : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "Преимущественно облачно. По ощущениям 10°"
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private let row1Label : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "Ветер"
        return view
    }()

    private let row2Label : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "Атмосферные осадки"
        return view
    }()

    private let row3Label : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "Облачность"
        return view
    }()
    
    private let windLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "2 m/s ССЗ"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return view
    }()

    private let percipitationLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "0%"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return view
    }()
    
    private let cloudyLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "29%"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
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
        contentView.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(degreeLabel)
        contentView.addSubview(row0ImageView)
        contentView.addSubview(row1ImageView)
        contentView.addSubview(row2ImageView)
        contentView.addSubview(row3ImageView)
        contentView.addSubview(row0Label)
        contentView.addSubview(row1Label)
        contentView.addSubview(row2Label)
        contentView.addSubview(row3Label)
        contentView.addSubview(windLabel)
        contentView.addSubview(percipitationLabel)
        contentView.addSubview(cloudyLabel)
        
        let constraints = [
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),
            
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            timeLabel.heightAnchor.constraint(equalToConstant: 22),
            
            degreeLabel.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor),
            degreeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            degreeLabel.heightAnchor.constraint(equalToConstant: 22),
            
            row0ImageView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            row0ImageView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 16),
            row0ImageView.heightAnchor.constraint(equalToConstant: 12),
            row0ImageView.widthAnchor.constraint(equalToConstant: 12),
            
            row1ImageView.leadingAnchor.constraint(equalTo: row0ImageView.leadingAnchor),
            row1ImageView.topAnchor.constraint(equalTo: row0ImageView.bottomAnchor, constant: 14),
            row1ImageView.widthAnchor.constraint(equalToConstant: 12),
            row1ImageView.heightAnchor.constraint(equalToConstant: 12),
            
            row2ImageView.leadingAnchor.constraint(equalTo: row1ImageView.leadingAnchor),
            row2ImageView.topAnchor.constraint(equalTo: row1ImageView.bottomAnchor, constant: 14),
            row2ImageView.widthAnchor.constraint(equalToConstant: 12),
            row2ImageView.heightAnchor.constraint(equalToConstant: 12),

            row3ImageView.leadingAnchor.constraint(equalTo: row2ImageView.leadingAnchor),
            row3ImageView.topAnchor.constraint(equalTo: row2ImageView.bottomAnchor, constant: 14),
            row3ImageView.widthAnchor.constraint(equalToConstant: 12),
            row3ImageView.heightAnchor.constraint(equalToConstant: 12),

            row0Label.centerYAnchor.constraint(equalTo: row0ImageView.centerYAnchor),
            row0Label.leadingAnchor.constraint(equalTo: row0ImageView.trailingAnchor, constant: 8),
            row0Label.widthAnchor.constraint(equalToConstant: 270),
            row0Label.heightAnchor.constraint(equalToConstant: 20),

            row1Label.centerYAnchor.constraint(equalTo: row1ImageView.centerYAnchor),
            row1Label.leadingAnchor.constraint(equalTo: row1ImageView.trailingAnchor, constant: 8),
            row1Label.widthAnchor.constraint(equalToConstant: 50),
            row1Label.heightAnchor.constraint(equalToConstant: 20),

            row2Label.centerYAnchor.constraint(equalTo: row2ImageView.centerYAnchor),
            row2Label.leadingAnchor.constraint(equalTo: row2ImageView.trailingAnchor, constant: 8),
            row2Label.widthAnchor.constraint(equalToConstant: 160),
            row2Label.heightAnchor.constraint(equalToConstant: 20),

            row3Label.centerYAnchor.constraint(equalTo: row3ImageView.centerYAnchor),
            row3Label.leadingAnchor.constraint(equalTo: row3ImageView.trailingAnchor, constant: 8),
            row3Label.widthAnchor.constraint(equalToConstant: 130),
            row3Label.heightAnchor.constraint(equalToConstant: 20),
            
            windLabel.centerYAnchor.constraint(equalTo: row1Label.centerYAnchor),
            windLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            windLabel.heightAnchor.constraint(equalToConstant: 20),
            
            percipitationLabel.centerYAnchor.constraint(equalTo: row2Label.centerYAnchor),
            percipitationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            percipitationLabel.heightAnchor.constraint(equalToConstant: 20),

            cloudyLabel.centerYAnchor.constraint(equalTo: row3Label.centerYAnchor),
            cloudyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cloudyLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

