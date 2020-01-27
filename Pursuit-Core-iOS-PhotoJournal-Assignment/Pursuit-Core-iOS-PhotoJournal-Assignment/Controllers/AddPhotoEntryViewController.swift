//
//  AddPhotoEntryViewController.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

enum PhotoState{
    case newPhoto
    case existingPhoto
}

class AddPhotoEntryViewController: UIViewController {
    
    var passedPhotoObj:Photo?
    
    public private(set) var photoState = PhotoState.newPhoto

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
