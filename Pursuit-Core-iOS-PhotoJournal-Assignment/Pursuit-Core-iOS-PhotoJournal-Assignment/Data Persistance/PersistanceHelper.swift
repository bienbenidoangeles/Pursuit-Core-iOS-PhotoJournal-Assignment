//
//  PersistanceHelper.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

enum DataPersistanceError:Error{
    case savingError(Error)
    case loadingError(Error)
    case deletingError(Error)
    case noData
    case fileDoesNotExist(String)
    case decodingError(Error)
}

class PersistanceHelper {
    private var photoObjs: [Photo]
    private var filename: String
    
    init(filename: String) {
      self.filename = filename
        self.photoObjs = []
    }
    
    private func save() throws{
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        do {
            let data = try PropertyListEncoder().encode(photoObjs)
            try data.write(to: url)
        } catch {
            throw DataPersistanceError.savingError(error)
        }
    }
    
    public func sync(photoObjs: [Photo]){
        self.photoObjs = photoObjs
        try? save()
    }
    
    public func create(photoObj: Photo) throws {
        photoObjs.append(photoObj)
        
        do {
            try save()
        } catch {
            throw DataPersistanceError.savingError(error)
        }
    }
    
    public func load() throws -> [Photo]{
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        if FileManager.default.fileExists(atPath: url.path){
            
            if let data = FileManager.default.contents(atPath: url.path){
                do {
                    photoObjs = try PropertyListDecoder().decode([Photo].self, from: data)
                } catch {
                    throw DataPersistanceError.decodingError(error)
                }
            } else {
                throw DataPersistanceError.noData
            }
        } else {
            throw DataPersistanceError.fileDoesNotExist(filename)
        }
        
        return photoObjs
    }
    
    @discardableResult
    public func update(_ oldItem: Photo, _ newItem: Photo) -> Bool{
        if let index = photoObjs.firstIndex(of: oldItem){
            let result = update(newItem, at: index)
            return result
        }
        return false
    }
    
    public func update(_ insertNewItem: Photo, at index: Int) -> Bool{
        photoObjs[index] = insertNewItem
        do{
            try save()
            return true
        } catch {
            return false
        }
    }
    
    public func delete(photo atIndex: Int) throws{
        photoObjs.remove(at: atIndex)
        
        do {
            try save()
        } catch {
            throw DataPersistanceError.deletingError(error)
        }
    }
}
