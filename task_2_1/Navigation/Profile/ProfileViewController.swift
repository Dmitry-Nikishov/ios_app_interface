//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Дмитрий Никишов on 29.06.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var profileHeaderView : ProfileHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileHeaderView = ProfileHeaderView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: 0,
                          height: 0))
        
        profileHeaderView.backgroundColor = .lightGray
        
        view.addSubview(profileHeaderView)
    }
    

    override func viewWillLayoutSubviews() {
        profileHeaderView.frame = view.frame
    }

}
