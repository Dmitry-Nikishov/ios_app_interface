//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 20.12.2021.
//

import UIKit

class SettingItemFactory {
    static func createControlItem(leftLabel : String,
                                  rightLabel : String,
                                  target : Any?,
                                  handler : Selector
                                ) -> UIStackView {
        let wrappedView = UIStackView()
        wrappedView.translatesAutoresizingMaskIntoConstraints = false
        wrappedView.alignment = .center
        
        let view = UISegmentedControl()
        view.selectedSegmentTintColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        view.setTitleTextAttributes(titleTextAttributes, for: .selected)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSegment(withTitle: leftLabel, at: 0, animated: false)
        view.insertSegment(withTitle: rightLabel, at: 1, animated: false)
        view.selectedSegmentIndex = 0
        view.setWidth(40, forSegmentAt: 0)
        view.setWidth(40, forSegmentAt: 1)
        view.addTarget(target, action: handler, for: .valueChanged)
                
        wrappedView.addArrangedSubview(view)
        return wrappedView
    }
    
    static func createLabelItem(text : String) -> UILabel
    {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = text
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .gray
        return view
    }
}

class SettingsView : UIView {
    private let cloud1Image : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cloud1")
        view.alpha = 0.3
        view.layer.compositingFilter = "screenBlendMode"
        return view
    }()
    
    private let cloud2Image : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cloud2")
        return view
    }()

    private let cloud3Image : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cloud3")
        return view
    }()

    private let controlPanelItem : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red : 0.914, green: 0.933, blue: 0.98, alpha: 1).cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let controlPanelItemHeader : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red : 0.153, green: 0.153, blue: 0.133, alpha: 1)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.7
        view.attributedText = NSMutableAttributedString(string: "Настройки",
                                                        attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        return view
    }()
    
    private let settingsLabelsStackViewItem : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.axis = .vertical
        view.alignment = .center
        return view
    }()

    private let settingsItemsStackViewItem : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    private let temperatureLabel: UILabel = {
        return SettingItemFactory.createLabelItem(text: "Температура")
    }()
    
    private let windSpeedLabel: UILabel = {
        return SettingItemFactory.createLabelItem(text: "Скорость ветра")
    }()
    
    private let timeFormatLabel: UILabel = {
        return SettingItemFactory.createLabelItem(text: "Формат времени")
    }()
    
    private let notificationLabel: UILabel = {
        return SettingItemFactory.createLabelItem(text: "Уведомления")
    }()

    @objc
    private func temperatureControlValueChanged(_ sender: UISegmentedControl) {
        print("Temperature : \(sender.selectedSegmentIndex)")
    }
    
    private lazy var temperatureSwitchWrapped: UIStackView = {
        return SettingItemFactory.createControlItem(leftLabel: "C",
                                                    rightLabel: "F",
                                                    target: self,
                                                    handler: #selector(temperatureControlValueChanged))
    }()

    @objc
    private func windSpeedControlValueChanged(_ sender: UISegmentedControl) {
        print("Wind speed : \(sender.selectedSegmentIndex)")
    }

    private lazy var windSpeedSwitchWrapped: UIStackView = {
        return SettingItemFactory.createControlItem(leftLabel: "Mi",
                                                    rightLabel: "Km",
                                                    target: self,
                                                    handler: #selector(windSpeedControlValueChanged))
    }()

    @objc
    private func timeFormatControlValueChanged(_ sender: UISegmentedControl) {
        print("Time format : \(sender.selectedSegmentIndex)")
    }

    private lazy var timeFormatSwitchWrapped: UIStackView = {
        return SettingItemFactory.createControlItem(leftLabel: "12",
                                                    rightLabel: "24",
                                                    target: self,
                                                    handler: #selector(timeFormatControlValueChanged))
    }()
    
    @objc
    private func notificationControlValueChanged(_ sender: UISegmentedControl) {
        print("Notification : \(sender.selectedSegmentIndex)")
    }

    private lazy var notificationSwitchWrapped: UIStackView = {
        return SettingItemFactory.createControlItem(leftLabel: "On",
                                                    rightLabel: "Off",
                                                    target: self,
                                                    handler: #selector(notificationControlValueChanged))
    }()
    
    @objc
    private func applySettingsButtonClicked()
    {
        print("apply settings")
    }
    
    private lazy var applySettingsButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Установить", for: .normal)
        button.layer.backgroundColor = UIColor(red: 0.949, green: 0.431, blue: 0.067, alpha: 1).cgColor
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(applySettingsButtonClicked), for:.touchUpInside)

        return button
   }()

    private func setupLayout() {
        self.addSubview(cloud1Image)
        self.addSubview(cloud2Image)
        self.addSubview(cloud3Image)
        self.addSubview(controlPanelItem)
        
        let constraints = [
            cloud1Image.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 37),
            cloud1Image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -129),
            cloud1Image.heightAnchor.constraint(equalToConstant: 58),
            cloud1Image.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            
            cloud2Image.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 121),
            cloud2Image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            cloud2Image.heightAnchor.constraint(equalToConstant: 94),
            cloud2Image.widthAnchor.constraint(equalToConstant: 182),
            
            cloud3Image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cloud3Image.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -95),
            cloud3Image.widthAnchor.constraint(equalToConstant: 216),
            cloud3Image.heightAnchor.constraint(equalToConstant: 65),
            
            controlPanelItem.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            controlPanelItem.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 241),
            controlPanelItem.widthAnchor.constraint(equalToConstant: 320),
            controlPanelItem.heightAnchor.constraint(equalToConstant: 330)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupControlPanelItem()
    {
        controlPanelItem.addSubview(controlPanelItemHeader)
        controlPanelItem.addSubview(settingsItemsStackViewItem)
        controlPanelItem.addSubview(settingsLabelsStackViewItem)
        controlPanelItem.addSubview(applySettingsButton)
        
        let constraints = [
            controlPanelItemHeader.widthAnchor.constraint(equalToConstant: 112),
            controlPanelItemHeader.heightAnchor.constraint(equalToConstant: 20),
            controlPanelItemHeader.leadingAnchor.constraint(equalTo: controlPanelItem.leadingAnchor, constant: 20),
            controlPanelItemHeader.topAnchor.constraint(equalTo: controlPanelItem.topAnchor, constant: 27),
            
            settingsLabelsStackViewItem.topAnchor.constraint(equalTo: controlPanelItemHeader.bottomAnchor, constant: 10),
            settingsLabelsStackViewItem.leadingAnchor.constraint(equalTo: controlPanelItem.leadingAnchor),
            settingsLabelsStackViewItem.widthAnchor.constraint(equalToConstant: 160),
            settingsLabelsStackViewItem.heightAnchor.constraint(equalToConstant: 220),
            
            settingsItemsStackViewItem.topAnchor.constraint(equalTo: controlPanelItemHeader.bottomAnchor, constant: 10),
            settingsItemsStackViewItem.trailingAnchor.constraint(equalTo: controlPanelItem.trailingAnchor),
            settingsItemsStackViewItem.widthAnchor.constraint(equalToConstant: 160),
            settingsItemsStackViewItem.heightAnchor.constraint(equalToConstant: 220),
            
            applySettingsButton.widthAnchor.constraint(equalToConstant: 250),
            applySettingsButton.heightAnchor.constraint(equalToConstant: 40),
            applySettingsButton.centerXAnchor.constraint(equalTo: controlPanelItem.centerXAnchor),
            applySettingsButton.bottomAnchor.constraint(equalTo: controlPanelItem.bottomAnchor, constant: -10)

        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupControlPanelContent()
    {
        settingsLabelsStackViewItem.addArrangedSubview(temperatureLabel)
        settingsLabelsStackViewItem.addArrangedSubview(windSpeedLabel)
        settingsLabelsStackViewItem.addArrangedSubview(timeFormatLabel)
        settingsLabelsStackViewItem.addArrangedSubview(notificationLabel)
        
        settingsItemsStackViewItem.addArrangedSubview(temperatureSwitchWrapped)
        settingsItemsStackViewItem.addArrangedSubview(windSpeedSwitchWrapped)
        settingsItemsStackViewItem.addArrangedSubview(timeFormatSwitchWrapped)
        settingsItemsStackViewItem.addArrangedSubview(notificationSwitchWrapped)
    }
    
    private func setupViews() {
        self.layer.backgroundColor = UIColor(red : 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor
                
        setupLayout()
        
        setupControlPanelItem()
        
        setupControlPanelContent()
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for SettingsView")
    }
}
