//
//  AddNewLocationPopup.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 28.01.2022.
//

import UIKit

class AddNewLocationPopup : UIViewController {
    public var closePopupHandler : UiViewClickHandlerWithStringParam?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        createTheView()
     }

    private let popUpTitle : UILabel = {
        let view = UILabel()
        view.text = "Введите местоположение"
        view.numberOfLines = 1
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 24)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.textAlignment = .center
        return view
    }()
    
    @objc func locationNameChanged(_ textField: UITextField) {
        if textField.hasText {
            applyButton.setTitle("Добавить", for: .normal)
        } else {
            applyButton.setTitle("Закрыть", for: .normal)
        }
    }
    
    private let locationNameTextField : UITextField = {
        let view = UITextField()
        view.addTarget(self, action: #selector(locationNameChanged), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.placeholder = "введите название"
        let paddingView = UIView(frame: CGRect(x : 0, y : 0,
                                               width : 4,
                                               height : view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        view.backgroundColor = .lightGray

        return view
    }()

    private func addEntryToDb()
    {
        if locationNameTextField.hasText {
            let locationName = locationNameTextField.text!
            let geoCode = YandexGeocoding.shared.getGeoCode(geocode: locationName)
            if let geoPosition = geoCode {
                let dbGeoPoint = DbGeoPoint(id: locationName,
                                            latitude: geoPosition.latitude,
                                            longitude: geoPosition.longitude)
                GeoPointsDB.shared.addGeoPoint(geoPoint: dbGeoPoint)
            }
        }
    }
    
    @objc
    private func applyButtonClickHandler()
    {
        addEntryToDb()
        dismiss(animated: true, completion: nil)
        closePopupHandler?(locationNameTextField.text ?? "")
    }
    
    private let applyButton : UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(applyButtonClickHandler), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Закрыть", for: .normal)
        view.backgroundColor = .systemBlue
        view.tintColor = .white
        view.layer.cornerRadius = 5
        return view
    }()

    private func createTheView() {
        let yCoord = self.view.bounds.height / 2 - 100

        let centeredView = UIView(frame: CGRect(x: self.view.bounds.width*0.05, y: yCoord, width: self.view.bounds.width*0.9, height: 200))
        centeredView.backgroundColor = .white
        centeredView.layer.cornerRadius = 7

        centeredView.addSubview(popUpTitle)
        centeredView.addSubview(locationNameTextField)
        centeredView.addSubview(applyButton)

        self.view.addSubview(centeredView)

        let constraints = [
        popUpTitle.topAnchor.constraint(equalTo: centeredView.topAnchor, constant: 10),
        popUpTitle.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
        popUpTitle.trailingAnchor.constraint(equalTo: centeredView.trailingAnchor),

        locationNameTextField.centerXAnchor.constraint(equalTo: centeredView.centerXAnchor),
        locationNameTextField.centerYAnchor.constraint(equalTo: centeredView.centerYAnchor),
        locationNameTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.9),
        locationNameTextField.heightAnchor.constraint(equalToConstant: 50),

        applyButton.bottomAnchor.constraint(equalTo: centeredView.bottomAnchor, constant: -10),
        applyButton.heightAnchor.constraint(equalToConstant: 50),
        applyButton.centerXAnchor.constraint(equalTo: centeredView.centerXAnchor),
        applyButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.9),
        ]

        NSLayoutConstraint.activate(constraints)
     }
}
