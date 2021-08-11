//
//  HabitCollectionViewCell.swift
//  ght
//
//  Created by Дмитрий Никишов on 31.07.2021.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    public weak var habitDetailsViewReloadableController : HabitDetailsViewReloadDelegate?
        
    public weak var habitId : Habit? {
        didSet {
            guard let habit = habitId else {
                return
            }
            
            isTracked = habit.isAlreadyTakenToday
            counterLabel.text = "Счетчик: \(habit.trackDates.count)"
            habitTitleLabel.text = habit.name
            scheduleInfoLabel.text = habit.dateString
            habitTitleLabel.textColor = habit.color
            
            if isTracked {
                trackView.layer.backgroundColor = UIColor.white.cgColor
                trackView.tintColor = habit.color
                trackView.image = UIImage(systemName: "checkmark.circle.fill")
                trackView.layer.borderWidth = 0
            } else {
                trackView.layer.borderWidth = 2
                trackView.layer.borderColor = habit.color.cgColor
            }
        }
    }
                
    private let counterLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private let habitTitleLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    private let scheduleInfoLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private lazy var trackView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.contentMode = .scaleAspectFill
        
        let tapGesture = UITapGestureRecognizer(target : self, action : #selector(trackViewClickHandler))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)

        return view
    }()
    
    private var isTracked : Bool = false
    
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
        
        contentView.addSubview(habitTitleLabel)
        contentView.addSubview(scheduleInfoLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(trackView)
                
        let tapGesture = UITapGestureRecognizer(target : self, action : #selector(showHabitDetailsHandler))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGesture)

        
        let constraints = [
            habitTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            habitTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            scheduleInfoLabel.leadingAnchor.constraint(equalTo: habitTitleLabel.leadingAnchor),
            scheduleInfoLabel.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: 10),
            
            counterLabel.leadingAnchor.constraint(equalTo: scheduleInfoLabel.leadingAnchor),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            trackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            trackView.widthAnchor.constraint(equalToConstant: 50),
            trackView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func trackViewClickHandler()
    {
        if (!isTracked) {
            if let habit = self.habitId {
                HabitsStore.shared.track(habit)
                habitDetailsViewReloadableController?.reloadContent()
            }
            
            isTracked = true
        }
    }
    
    @objc private func showHabitDetailsHandler()
    {
        guard let title = habitTitleLabel.text,
              let date = self.habitId?.date,
              let trackedDates = self.habitId?.trackDates
        else {
            return
        }
        
        habitDetailsViewReloadableController?.showHabitDetails(
            habitTitle: title,
            habitColor: trackView.tintColor,
            habitDate: date,
            trackedDates: trackedDates)
    }
}
