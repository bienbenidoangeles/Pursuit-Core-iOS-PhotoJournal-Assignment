//
//  ViewController.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/21/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

enum ScrollDirection:Int{
    case vertical
    case horizontal
}

//protocol EditButtonOfCellDelegate: AnyObject {
//    func editButtonPressed(photoObj: Photo)
//}

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    var collectionViewScrollDirection = ScrollDirection.vertical.rawValue{
        didSet{
            changeScrollDirection()
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    private var dataPersistance = PersistanceHelper(filename: "PhotoJournalData.plist")
        
    private var photoObjects = [Photo](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var bgColorSettings:UIColor = .systemGray{
        didSet{
            view.backgroundColor = bgColorSettings
        }
    }
    
    //public weak var delegate:EditButtonOfCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dataPersistance.description)
        updateUI()
        loadPhotoObjects()
        delegatesAndDataSources()
        print(photoObjects.count)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem){
        showSettings()
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIBarButtonItem) {
       showAddPhotoEntryVC()
    }
    
    private func showSettings(){
        guard let settingsViewController = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsTableViewController else {
            fatalError()
        }
        
        settingsViewController.delegate = self

        //add delegate
        
        
        present(settingsViewController, animated: true)
    }
    
    private func showAddPhotoEntryVC(){
        guard let addNewPhotoEntryVC = self.storyboard?.instantiateViewController(identifier: "AddPhotoEntryViewController") as? AddPhotoEntryViewController else {
            fatalError()
        }
    
        //add delegate
        addNewPhotoEntryVC.delegate = self
               
        present(addNewPhotoEntryVC, animated: true)
    }
    
    private func changeScrollDirection(){
        
        if collectionViewScrollDirection == 0{
            //collectionViewScrollDirection = 1
            collectionViewLayout.scrollDirection = .vertical
        } else {
            //collectionViewScrollDirection = 0
            collectionViewLayout.scrollDirection = .horizontal
        }
    }
    
    private func loadPhotoObjects(){
        do{
            photoObjects = try dataPersistance.load()
        } catch {
            print("Load error: \(error)")
            //showAlert(title: "Load Error", message: "\(error)")
        }
    }
    
    private func updateUI(){
        changeScrollDirection()
        if let bgColor = UserDefaults.standard.object(forKey: UserDefaultKeys.backgroundColor) as? [CGFloat]{
            view.backgroundColor = UIColor(displayP3Red: bgColor[0], green: bgColor[1], blue: bgColor[2], alpha: 1.0)
        }
    }
    
    func delegatesAndDataSources(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //collectionView.backgroundColor = bgColor
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else {
          fatalError("could not downcast to an PhotoCell")
        }
        
        let photo = photoObjects[indexPath.row]
        cell.delegate = self
        
        cell.configureCell(photoObj: photo)
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = UIScreen.main.bounds.size.width
        let itemWidth = maxWidth * 0.8
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

extension CollectionViewController:AddOrUpdatePhotoEntryDelegate{
    func createOrUpdatePhotoEntry(_ oldPhotoEntry: Photo?, _ newPhotoEntry: Photo, photoState: PhotoState) {
        if photoState == .newPhoto{
            photoObjects.append(newPhotoEntry)
            do{
                try dataPersistance.create(photoObj: newPhotoEntry)
            } catch {
                showAlert(title: "Saving Error", message: "\(error)")
            }
        } else if photoState == .existingPhoto{
            dataPersistance.update(oldPhotoEntry!, newPhotoEntry)
            loadPhotoObjects()
        }
    }
}

extension CollectionViewController: SettingsButtonPressed{
    func settingsParameters(_ scrollDirection: Int, _ bgColor: [CGFloat]) {
        collectionViewScrollDirection = scrollDirection
        bgColorSettings = UIColor(displayP3Red: bgColor[0], green: bgColor[1], blue: bgColor[2], alpha: 1.0)
    }
}

extension CollectionViewController: PhotoCellDelegate{
    func didPressOptionalButton(_ photoCell: PhotoCell) {
        guard let indexPath = collectionView.indexPath(for: photoCell) else {
            return
        }
        
        let selectedPhotoObj = photoObjects[indexPath.row]
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){ [weak self] alertAction in
            self?.deletePhotoPbj(indexPath: indexPath)
        }
        let editAction = UIAlertAction(title: "Edit", style: .default){[weak self]alertAction in
            //print("row", indexPath.row, "section", indexPath.section)
            self?.showCreatePhotoVC(selectedPhotoObj, indexPath)
            
        }
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(editAction)
        alertVC.addAction(deleteAction)
        alertVC.addAction(shareAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    private func showCreatePhotoVC(_ photoObj: Photo? = nil, _ indexPath: IndexPath? = nil){
        guard let addPhotoEntryViewController = storyboard?.instantiateViewController(identifier: "AddPhotoEntryViewController") as? AddPhotoEntryViewController else {
            fatalError("failed to downcast to AddPhotoEntryViewController")
        }
        //self.delegate?.editButtonPressed(photoObj: photoObj!)
        addPhotoEntryViewController.delegate = self
        addPhotoEntryViewController.passedPhotoObj = photoObj
        present(addPhotoEntryViewController, animated: true, completion: nil)
        
    }
    
    private func deletePhotoPbj(indexPath: IndexPath){
        dataPersistance.sync(photoObjs: photoObjects)
        
        do {
            photoObjects = try dataPersistance.load()
        } catch {
            showAlert(title: "Failed to load photos to delete", message: "\(error)")
        }
        
        photoObjects.remove(at: indexPath.row)
//        collectionView.deleteItems(at: [indexPath])
        
        do{
            try dataPersistance.delete(photo: indexPath.row)
        } catch {
            showAlert(title: "Deletion Error", message: "\(error)")
        }
    }
    
}

