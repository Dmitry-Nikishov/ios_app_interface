//
//  OnboardingView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 18.12.2021.
//

import UIKit

class OnboardingView : UIView {
    public var useGeolocationClickHandler : UiViewClickHandler?
    public var denyGeolocationClickHandler : UiViewClickHandler?

    @objc
    private func useGeolocationHandler()
    {
        useGeolocationClickHandler?()
    }

    @objc
    private func denyGeolocationHandler()
    {
        denyGeolocationClickHandler?()
    }

    private lazy var denyUseGeolocationBtn : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentHorizontalAlignment = .right
        view.titleLabel?.numberOfLines = 1
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 16)
        view.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
        view.addTarget(self, action: #selector(denyGeolocationHandler), for: .touchUpInside)
        return view
    }()
    
    private let useGeolocationBtn : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor(red : 0.949, green: 0.431, blue: 0.067, alpha: 1).cgColor
        view.layer.cornerRadius = 10
        view.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 12)
        view.titleLabel?.numberOfLines = 1
        view.titleLabel?.adjustsFontSizeToFitWidth = true

        view.setTitle("ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ УСТРОЙСТВА", for: .normal)

        view.addTarget(self, action: #selector(useGeolocationHandler), for: .touchUpInside)

        return view
    }()

    private let label_1 : UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.973, green: 0.961, blue: 0.961, alpha: 1)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        view.attributedText = NSMutableAttributedString(string: "Разрешить приложению Weather использовать данные \nо местоположении вашего устройства ", attributes: [NSAttributedString.Key.kern : 0.16, NSAttributedString.Key.paragraphStyle : paragraphStyle])
        view.font = UIFont(name: "Rubik-Regular", size: 16)
        return view
    }()

    private let label_2 : UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        view.attributedText = NSMutableAttributedString(string: "Чтобы получить более точные прогнозы погоды во время движения или путешествия", attributes: [NSAttributedString.Key.kern : 0.14, NSAttributedString.Key.paragraphStyle : paragraphStyle])
        view.font = UIFont(name: "Rubik-Regular", size: 14)
        return view
    }()

    private let label_3 : UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        view.attributedText = NSMutableAttributedString(string: "Вы можете изменить свой выбор в любое время из меню приложения", attributes: [NSAttributedString.Key.kern : 0.28, NSAttributedString.Key.paragraphStyle : paragraphStyle])
        view.font = UIFont(name: "Rubik-Regular", size: 14)
        return view
    }()

    private let onboardingImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "OnboardingImage")
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
       
    private lazy var scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageArea : UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    private let contentArea : UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    private func setupScrollView()
    {
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupAreas()
    {
        let constraints = [
            imageArea.heightAnchor.constraint(equalToConstant: 334 + 62),
            contentArea.heightAnchor.constraint(equalToConstant: 350)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupImage()
    {
        imageArea.addSubview(onboardingImageView)
        let constraints = [
            onboardingImageView.topAnchor.constraint(equalTo: imageArea.topAnchor, constant: 62),
            onboardingImageView.heightAnchor.constraint(equalToConstant: 334),
            onboardingImageView.leadingAnchor.constraint(equalTo: imageArea.leadingAnchor, constant: 35.5),
            onboardingImageView.trailingAnchor.constraint(equalTo: imageArea.trailingAnchor, constant : -35),
        ]
        
        constraints.forEach {
            $0.priority = .init(rawValue: 990)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
     
    private func setupContentArea()
    {
        contentArea.addSubview(label_1)
        contentArea.addSubview(label_2)
        contentArea.addSubview(label_3)
        contentArea.addSubview(useGeolocationBtn)
        contentArea.addSubview(denyUseGeolocationBtn)
        
        let constraints = [
            label_1.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor, constant: 19),
            label_1.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor, constant: -34),
            label_1.topAnchor.constraint(equalTo: contentArea.topAnchor, constant: 10),
            
            label_2.topAnchor.constraint(equalTo: label_1.bottomAnchor, constant: 20),
            label_2.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor, constant: 19),
            label_2.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor, constant: -42),
            
            label_3.topAnchor.constraint(equalTo: label_2.bottomAnchor, constant: 10),
            label_3.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor, constant: 19),
            label_3.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor, constant: -34),
            
            useGeolocationBtn.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor, constant: 17),
            useGeolocationBtn.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor, constant: -18),
            useGeolocationBtn.topAnchor.constraint(equalTo: label_3.bottomAnchor, constant: 20),
            useGeolocationBtn.heightAnchor.constraint(equalToConstant: 40),
            
            denyUseGeolocationBtn.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor, constant: 36),
            denyUseGeolocationBtn.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor, constant: -17),
            denyUseGeolocationBtn.heightAnchor.constraint(equalToConstant: 40),
            denyUseGeolocationBtn.topAnchor.constraint(equalTo: useGeolocationBtn.bottomAnchor, constant: 20)
        ]
        
        
        constraints.forEach {
            $0.priority = .init(rawValue: 990)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupLayout()
    {
        self.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        scrollViewContainer.addArrangedSubview(imageArea)
        scrollViewContainer.addArrangedSubview(contentArea)
        
        setupScrollView()
        
        setupAreas()
        
        setupImage()
        
        setupContentArea()
    }
        
    private func setupViews()
    {
        self.layer.backgroundColor = UIColor(red : 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor
                
        setupLayout()
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for OnboardingView")
    }
}
