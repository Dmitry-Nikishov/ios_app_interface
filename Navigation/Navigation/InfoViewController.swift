//
//  InfoViewController.swift
//  Navigation
//
//  Created by Дмитрий Никишов on 22.06.2021.
//

import UIKit

class InfoViewController: UIViewController {

    @IBAction func showAlert(_ sender: Any) {
        let vc = UIAlertController(title: "Ui Alert Title", message : "Ui Alert Msg", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel alert")
        }
        
        vc.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            print("Ok alert")
        }

        vc.addAction(okAction)
        
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}
