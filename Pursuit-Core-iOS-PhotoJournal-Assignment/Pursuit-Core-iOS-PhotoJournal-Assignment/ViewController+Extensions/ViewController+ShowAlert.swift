//
//  ViewController+ShowAlert.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

extension UIViewController{
    func showAlert(title:String, message: String, completion: ((UIAlertAction) -> Void)? = nil){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertVC.addAction(okButton)
        present(alertVC, animated: true, completion: nil)
    }
}
