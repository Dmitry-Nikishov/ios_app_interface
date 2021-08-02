//
//  InfoViewController.swift
//  ght
//
//  Created by Дмитрий Никишов on 27.07.2021.
//

import UIKit

class InfoViewController: UIViewController {
    private let info : String =
        """
        Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму :
        
        1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага
        
        2. Выдержать 2 дня в прежнем состоянии самоконтроля.
        
        3. Отметить в дневнике первую неделю изменений и подвести первые итоги - что оказалось тяжело, что - легче, с чем еще предстоит серьезно бороться.
        
        4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ
        от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.
        
        5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от
        прошлого негатива и двигается в нужном направлении с хорошей динамикой.
        
        6. На 90-й день соблюдения техники все лишнее из 'прошлой жизни' перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.
        
        Источник psychbook.ru
        """
    
    private let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .onDrag
        view.isScrollEnabled = true
        return view
    }()

    private let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let infoTitleLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Привычка за 21 день"
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()

    private lazy var infoLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.text = self.info
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeArea = view.layoutMarginsGuide
        
        setupView()
    }
    
    private var safeArea : UILayoutGuide!

    private func setupView()
    {
        view.backgroundColor = .white
        title = "Информация"
        
        view.addSubview(scrollView)
        
        containerView.addSubview(infoTitleLabel)
        containerView.addSubview(infoLabel)
        
        scrollView.addSubview(containerView)
        
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            infoTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            infoTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            infoTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            infoLabel.leadingAnchor.constraint(equalTo: infoTitleLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            infoLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 10),
            infoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
