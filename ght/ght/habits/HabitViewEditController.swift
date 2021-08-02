//
//  HabitViewEditController.swift
//  ght
//
//  Created by Дмитрий Никишов on 02.08.2021.
//

import UIKit

class HabitViewEditController: UIViewController {
    public weak var dataRefresher : HabitDataReloadDelegate?
    
    public var controllerTitle : String? {
        didSet {
            guard let title = controllerTitle else {
                return
            }
            
            userHabitContent.text = title
        }
    }
    
    public var habitColor : UIColor? {
        didSet {
            guard let color = habitColor else {
                return
            }
            
            colorSelector.backgroundColor = color
        }
    }
    
    public var habitDate : Date? {
        didSet {
            guard let date = habitDate else {
                return
            }
            
            let initialDate = DateToFromStringConverter.toString(date: date)
            scheduleTimeLabel.text = "\(initialDate)"
            datePicker.date = date
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let editButton = UIBarButtonItem(title: "Править",
                        style: .plain,
                        target: self,
                        action: #selector(editHabitHandler))

        editButton.tintColor = .systemPurple
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationController?.navigationBar.tintColor = .systemPurple
        title = "Править"
        
        setupView()
    }
    
    private let titleHabitLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Название"
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private let userHabitContent : UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Бегать по утрам, спать по 8 часов и т.п."
        return view
    }()
    
    private let colorLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Цвет"
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private lazy var colorSelector : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        view.layer.cornerRadius = 25
        
        let tapGesture = UITapGestureRecognizer(target : self, action : #selector(selectColorHandler))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)

        return view
    }()
    
    private let timeItemLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Время"
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private let scheduleLabel : UILabel = {
        let view = UILabel()
        view.text = "Каждый день в "
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textAlignment = .left
        view.sizeToFit()
        return view
    }()

    private let scheduleTimeLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.textColor = .systemPurple
        view.textAlignment = .left
        return view
    }()

    private lazy var datePicker : UIDatePicker = {
        let view = UIDatePicker()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.timeZone = NSTimeZone.local
        view.datePickerMode = .time
        view.preferredDatePickerStyle = .wheels
        view.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return view
    }()
    
    private lazy var deleteButton : UIButton = {
        let view = UIButton()
        view.setTitle("Удалить привычку", for: .normal)
        view.setTitleColor(.systemRed, for : .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(deleteHabitHandler), for: .touchUpInside)
        return view
    }()
    
    private func setupView()
    {
        view.addSubview(titleHabitLabel)
        view.addSubview(userHabitContent)
        view.addSubview(colorLabel)
        view.addSubview(colorSelector)
        view.addSubview(timeItemLabel)
        view.addSubview(scheduleLabel)
        view.addSubview(scheduleTimeLabel)
        view.addSubview(datePicker)
        view.addSubview(deleteButton)
        
        let constraints = [
            titleHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleHabitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleHabitLabel.heightAnchor.constraint(equalToConstant: 20),
            
            userHabitContent.leadingAnchor.constraint(equalTo: titleHabitLabel.leadingAnchor),
            userHabitContent.topAnchor.constraint(equalTo: titleHabitLabel.bottomAnchor, constant: 10),
            userHabitContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userHabitContent.heightAnchor.constraint(equalToConstant: 20),

            colorLabel.topAnchor.constraint(equalTo: userHabitContent.bottomAnchor, constant: 10),
            colorLabel.leadingAnchor.constraint(equalTo: userHabitContent.leadingAnchor),
            colorLabel.heightAnchor.constraint(equalToConstant: 20),

            colorSelector.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 10),
            colorSelector.leadingAnchor.constraint(equalTo: colorLabel.leadingAnchor),
            colorSelector.widthAnchor.constraint(equalToConstant: 50),
            colorSelector.heightAnchor.constraint(equalToConstant: 50),

            timeItemLabel.topAnchor.constraint(equalTo: colorSelector.bottomAnchor, constant: 10),
            timeItemLabel.leadingAnchor.constraint(equalTo: colorSelector.leadingAnchor),
            timeItemLabel.heightAnchor.constraint(equalToConstant: 20),

            scheduleLabel.topAnchor.constraint(equalTo: timeItemLabel.bottomAnchor, constant: 10),
            scheduleLabel.leadingAnchor.constraint(equalTo: timeItemLabel.leadingAnchor),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            scheduleTimeLabel.topAnchor.constraint(equalTo: scheduleLabel.topAnchor),
            scheduleTimeLabel.heightAnchor.constraint(equalToConstant: 20),
            scheduleTimeLabel.leadingAnchor.constraint(equalTo: scheduleLabel.trailingAnchor),

            datePicker.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: scheduleLabel.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: userHabitContent.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 200),

            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker)
    {
        let selectedDate = DateToFromStringConverter.toString(date: sender.date)
        scheduleTimeLabel.text = "\(selectedDate)"
    }

    @objc private func editHabitHandler()
    {
//        print("edit")
    }
    
    @objc private func selectColorHandler()
    {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func deleteHabitHandler()
    {
        guard let habitName = userHabitContent.text else {
            return
        }
        
        let vc = UIAlertController(title: "Удалить привычку", message : "Вы хотите удалить привычку \(habitName)", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        vc.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Удалить", style: .default) { _ in
            let habitIdxToRemoveOptional = HabitsStore.shared.habits.firstIndex{ $0.name == habitName }
            
            if let habitIdxToRemove = habitIdxToRemoveOptional {
                HabitsStore.shared.habits.remove(at: habitIdxToRemove)
                self.dataRefresher?.reloadContent()
                self.navigationController?.popToRootViewController(animated: false)
            }
        }

        vc.addAction(okAction)
        
        present(vc, animated: true, completion: nil)
    }
}

extension HabitViewEditController : UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            dismiss(animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorSelector.backgroundColor = viewController.selectedColor
    }
}
