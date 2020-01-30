//
//  FileManager+Extensions.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

extension FileManager{
    static func getDocumentsDirectory() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func pathToDocumentsDirectory(with filename: String) -> URL{
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
}
