//
//  ViewController.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/21/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var photoObjects = [Photo]()
    private var dataPeristance = PersistanceHelper(filename: "PhotoJournalData.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadPhotoObjects()
    }
    
    @IBAction func addPictureButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    private func loadPhotoObjects(){
        do{
            photoObjects = try dataPeristance.load()
        } catch {
            showAlert(title: "Load Error", message: "\(error)")
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

extension CollectionViewController: PhotoCellDelegate{
    func didPressOptionalButton(_ photoCell: PhotoCell) {
        guard let indexPath = collectionView.indexPath(for: photoCell) else {
            return
        }
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){ [weak self] alertAction in
            self?.deletePhotoPbj(indexPath: indexPath)
        }
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: nil)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(deleteAction)
        alertVC.addAction(editAction)
        alertVC.addAction(shareAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    private func deletePhotoPbj(indexPath: IndexPath){
        dataPeristance.sync(photoObjs: photoObjects)
        
        do {
            photoObjects = try dataPeristance.load()
        } catch {
            showAlert(title: "Failed to load Photos", message: "\(error)")
        }
        
        photoObjects.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        
        do{
            try dataPeristance.delete(photo: indexPath.row)
        } catch {
            showAlert(title: "Delete Error", message: "\(error)")
        }
    }
    
}

