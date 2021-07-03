//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Дмитрий Никишов on 29.06.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    private lazy var manualButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("New Btn", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(manualButton)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            manualButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            manualButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            manualButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])

    }
}
