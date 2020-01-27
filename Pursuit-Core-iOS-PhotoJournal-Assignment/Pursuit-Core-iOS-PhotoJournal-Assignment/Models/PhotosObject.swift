//
//  PhotosObject.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

struct Photo: Codable & Equatable{
    let imageData: Data
    let photoTitle:String
    let date: String
    let identifier = UUID().uuidString
}
