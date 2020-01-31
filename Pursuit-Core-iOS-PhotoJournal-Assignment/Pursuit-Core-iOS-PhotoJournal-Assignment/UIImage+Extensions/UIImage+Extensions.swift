//
//  UIImage+Extensions.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/30/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

extension UIImage{
    func isEqualToImage(_ image: UIImage) -> Bool{
        return self.pngData() == image.pngData()
    }
}
