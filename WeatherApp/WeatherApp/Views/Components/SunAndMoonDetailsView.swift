//
//  SunAndMoonDetailsView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 09.01.2022.
//

import UIKit

class SunAndMoonDetailsView : UIView
{
    private let viewLeftLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18)
        view.text = "Солнце и Луна"
        return view
    }()
    
    private let viewRightLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "Полнолуние"
        return view
    }()
    
    private let viewRightImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "blue_circle")
        return view
    }()
    
    private let column0View : UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let column1View : UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let columnSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableColumnView : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    
    private let column0Row0View : UIView = {
        let view = UIView()
        return view
    }()

    private let column0Row1View : UIView = {
        let view = UIView()
        return view
    }()

    private let column0Row2View : UIView = {
        let view = UIView()
        return view
    }()

    private let column1Row0View : UIView = {
        let view = UIView()
        return view
    }()

    private let column1Row1View : UIView = {
        let view = UIView()
        return view
    }()

    private let column1Row2View : UIView = {
        let view = UIView()
        return view
    }()

    private func setupTableColumns()
    {
        addSubview(tableColumnView)

        tableColumnView.addArrangedSubview(column0View)
        tableColumnView.addArrangedSubview(columnSeparatorView)
        tableColumnView.addArrangedSubview(column1View)
        
        column0View.addArrangedSubview(column0Row0View)
        column0View.addArrangedSubview(column0Row1View)
        column0View.addArrangedSubview(column0Row2View)

        column1View.addArrangedSubview(column1Row0View)
        column1View.addArrangedSubview(column1Row1View)
        column1View.addArrangedSubview(column1Row2View)

        let constraints = [
            tableColumnView.topAnchor.constraint(equalTo: viewLeftLabel.bottomAnchor),
            tableColumnView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableColumnView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            tableColumnView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            column0View.widthAnchor.constraint(equalTo: column1View.widthAnchor),
            columnSeparatorView.widthAnchor.constraint(equalToConstant: 1)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupHeader()
    {
        addSubview(viewLeftLabel)
        addSubview(viewRightLabel)
        addSubview(viewRightImageView)
        
        let constraints = [
            viewLeftLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            viewLeftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            viewLeftLabel.heightAnchor.constraint(equalToConstant: 22),
            
            viewRightLabel.topAnchor.constraint(equalTo: viewLeftLabel.topAnchor),
            viewRightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            viewRightLabel.heightAnchor.constraint(equalToConstant: 20),
            
            viewRightImageView.centerYAnchor.constraint(equalTo: viewRightLabel.centerYAnchor),
            viewRightImageView.trailingAnchor.constraint(equalTo: viewRightLabel.leadingAnchor, constant: -4),
            viewRightImageView.heightAnchor.constraint(equalToConstant: 8),
            viewRightImageView.widthAnchor.constraint(equalToConstant: 8)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private let sunImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "sunny")
        return view
    }()
    
    private let sunDurationLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.text = "14ч 27мин"
        return view
    }()
    
    private func configureColumn0Row0()
    {
        column0Row0View.addSubview(sunImageView)
        column0Row0View.addSubview(sunDurationLabel)
        
        let constraints = [
            sunImageView.leadingAnchor.constraint(equalTo: column0Row0View.leadingAnchor, constant: 10),
            sunImageView.widthAnchor.constraint(equalToConstant: 20),
            sunImageView.heightAnchor.constraint(equalToConstant: 24),
            sunImageView.centerYAnchor.constraint(equalTo: column0Row0View.centerYAnchor),
            
            sunDurationLabel.topAnchor.constraint(equalTo: column0Row0View.topAnchor),
            sunDurationLabel.bottomAnchor.constraint(equalTo: column0Row0View.bottomAnchor),
            sunDurationLabel.trailingAnchor.constraint(equalTo: column0Row0View.trailingAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private let column0Row1LeftLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Восход"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return view
    }()

    private let column0Row1RightLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "05:19"
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()

    private func configureColumn0Row1()
    {
        column0Row1View.addSubview(column0Row1LeftLabel)
        column0Row1View.addSubview(column0Row1RightLabel)
        
        let constraints = [
            column0Row1LeftLabel.leadingAnchor.constraint(equalTo: column0Row1View.leadingAnchor, constant: 10),
            column0Row1LeftLabel.centerYAnchor.constraint(equalTo: column0Row1View.centerYAnchor),
            
            column0Row1RightLabel.centerYAnchor.constraint(equalTo: column0Row1View.centerYAnchor),
            column0Row1RightLabel.trailingAnchor.constraint(equalTo: column0Row1View.trailingAnchor, constant: -10)
        ]
            
        NSLayoutConstraint.activate(constraints)
    }
    
    private let column0Row2LeftLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Заход"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return view
    }()

    private let column0Row2RightLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "05:19"
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()

    private func configureColumn0Row2()
    {
        column0Row2View.addSubview(column0Row2LeftLabel)
        column0Row2View.addSubview(column0Row2RightLabel)
        
        let constraints = [
            column0Row2LeftLabel.leadingAnchor.constraint(equalTo: column0Row2View.leadingAnchor, constant: 10),
            column0Row2LeftLabel.centerYAnchor.constraint(equalTo: column0Row2View.centerYAnchor),
            
            column0Row2RightLabel.centerYAnchor.constraint(equalTo: column0Row2View.centerYAnchor),
            column0Row2RightLabel.trailingAnchor.constraint(equalTo: column0Row2View.trailingAnchor, constant: -10)
        ]
            
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureColumn0()
    {
        configureColumn0Row0()
        configureColumn0Row1()
        configureColumn0Row2()
    }

    private let moonImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "moon")
        return view
    }()
    
    private let moonDurationLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.text = "14ч 27мин"
        return view
    }()

    private func configureColumn1Row0()
    {
        column1Row0View.addSubview(moonImageView)
        column1Row0View.addSubview(moonDurationLabel)
        
        let constraints = [
            moonImageView.leadingAnchor.constraint(equalTo: column1Row0View.leadingAnchor, constant: 10),
            moonImageView.widthAnchor.constraint(equalToConstant: 20),
            moonImageView.heightAnchor.constraint(equalToConstant: 24),
            moonImageView.centerYAnchor.constraint(equalTo: column1Row0View.centerYAnchor),
            
            moonDurationLabel.topAnchor.constraint(equalTo: column1Row0View.topAnchor),
            moonDurationLabel.bottomAnchor.constraint(equalTo: column1Row0View.bottomAnchor),
            moonDurationLabel.trailingAnchor.constraint(equalTo: column1Row0View.trailingAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    private let column1Row1LeftLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Восход"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return view
    }()

    private let column1Row1RightLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "05:19"
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()

    private func configureColumn1Row1()
    {
        column1Row1View.addSubview(column1Row1LeftLabel)
        column1Row1View.addSubview(column1Row1RightLabel)
        
        let constraints = [
            column1Row1LeftLabel.leadingAnchor.constraint(equalTo: column1Row1View.leadingAnchor, constant: 10),
            column1Row1LeftLabel.centerYAnchor.constraint(equalTo: column1Row1View.centerYAnchor),
            
            column1Row1RightLabel.centerYAnchor.constraint(equalTo: column1Row1View.centerYAnchor),
            column1Row1RightLabel.trailingAnchor.constraint(equalTo: column1Row1View.trailingAnchor, constant: -10)
        ]
            
        NSLayoutConstraint.activate(constraints)
    }
    
    private let column1Row2LeftLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Заход"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return view
    }()

    private let column1Row2RightLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "05:19"
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()

    private func configureColumn1Row2()
    {
        column1Row2View.addSubview(column1Row2LeftLabel)
        column1Row2View.addSubview(column1Row2RightLabel)
        
        let constraints = [
            column1Row2LeftLabel.leadingAnchor.constraint(equalTo: column1Row2View.leadingAnchor, constant: 10),
            column1Row2LeftLabel.centerYAnchor.constraint(equalTo: column1Row2View.centerYAnchor),
            
            column1Row2RightLabel.centerYAnchor.constraint(equalTo: column1Row2View.centerYAnchor),
            column1Row2RightLabel.trailingAnchor.constraint(equalTo: column1Row2View.trailingAnchor, constant: -10)
        ]
            
        NSLayoutConstraint.activate(constraints)
    }

    private func configureColumn1()
    {
        configureColumn1Row0()
        configureColumn1Row1()
        configureColumn1Row2()
    }

    private func setupView()
    {
        setupHeader()
        
        setupTableColumns()
        
        configureColumn0()
        
        configureColumn1()
    }
    
    init(viewFrame : CGRect)
    {
        super.init(frame: viewFrame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented for SunAndMoonDetailsView")
    }
}

