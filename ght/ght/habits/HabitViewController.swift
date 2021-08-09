//
//  HabitViewController.swift
//  ght
//
//  Created by Дмитрий Никишов on 29.07.2021.
//

import UIKit

class HabitViewController: UIViewController {
    public weak var dataRefresher : HabitDataReloadDelegate?
    
    private let titleHabitLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Название"
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private let userHabitInput : UITextField = {
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
    
    @objc private func selectColorHandler()
    {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker)
    {
        let selectedDate = DateToFromStringConverter.toString(date: sender.date)        
        scheduleTimeLabel.text = "\(selectedDate)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupLayout()
    {
        view.addSubview(titleHabitLabel)
        view.addSubview(userHabitInput)
        view.addSubview(colorLabel)
        view.addSubview(colorSelector)
        view.addSubview(timeItemLabel)
        view.addSubview(scheduleLabel)
        view.addSubview(scheduleTimeLabel)
        view.addSubview(datePicker)
        
        let constraints = [
            titleHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleHabitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleHabitLabel.heightAnchor.constraint(equalToConstant: 20),
            
            userHabitInput.leadingAnchor.constraint(equalTo: titleHabitLabel.leadingAnchor),
            userHabitInput.topAnchor.constraint(equalTo: titleHabitLabel.bottomAnchor, constant: 10),
            userHabitInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userHabitInput.heightAnchor.constraint(equalToConstant: 20),

            colorLabel.topAnchor.constraint(equalTo: userHabitInput.bottomAnchor, constant: 10),
            colorLabel.leadingAnchor.constraint(equalTo: userHabitInput.leadingAnchor),
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
            datePicker.trailingAnchor.constraint(equalTo: userHabitInput.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        NSLayoutConstraint.activate(constraints)        
    }
    
    private func setupView()
    {
        title = "Создать"
        
        let createHabitButton = UIBarButtonItem(title: "Создать",
                        style: .plain,
                        target: self,
                        action: #selector(createNewHabitHandler))
        
        createHabitButton.tintColor = .systemPurple

        let cancelAddingHabitButton = UIBarButtonItem(title : "Отменить",
                        style: .plain,
                        target: self,
                        action: #selector(cancelCreationNewHabitHandler))
        cancelAddingHabitButton.tintColor = .systemPurple

        self.navigationItem.rightBarButtonItem = createHabitButton
        self.navigationItem.leftBarButtonItem = cancelAddingHabitButton
        
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func getUserInputDate() -> Date?
    {
        let dateAsString = scheduleTimeLabel.text ?? ""
        return DateToFromStringConverter.fromString(dateAsString: dateAsString)
    }
    
    @objc private func createNewHabitHandler()
    {
        defer {
            self.navigationController?.popViewController(animated: false)
        }
        
        guard let userDate = getUserInputDate(),
              let habitText = userHabitInput.text,
              let selectedColor = colorSelector.backgroundColor
              else {
            return
        }
                
        let newHabit = Habit(name: habitText,
                             date: userDate,
                             color: selectedColor)
        let store = HabitsStore.shared
        store.habits.append(newHabit)
        self.dataRefresher?.reloadContent()
    }

    @objc private func cancelCreationNewHabitHandler()
    {
        self.navigationController?.popViewController(animated: false)
    }
}

extension HabitViewController : UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            dismiss(animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorSelector.backgroundColor = viewController.selectedColor
    }
}
