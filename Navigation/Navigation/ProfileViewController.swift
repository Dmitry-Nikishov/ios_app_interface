//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Дмитрий Никишов on 22.06.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "posts" else {
            return
        }
        
        let dataForPostview = Post(title: "Post view title from segue")
        
        let vc = segue.destination
        vc.title = dataForPostview.title
    }
}
