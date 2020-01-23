//
//  PhotoCell.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: AnyObject {
    func didPressOptionalButton(_ photoCell: PhotoCell)
}

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: PhotoCellDelegate!
    
    @IBAction func photoOptionsButtonPressed(_ sender: UIButton) {
        
        delegate.didPressOptionalButton(self)
        
//        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
//        let editAction = UIAlertAction(title: "Edit", style: .default, handler: nil)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertVC.addAction(deleteAction)
//        alertVC.addAction(editAction)
//        alertVC.addAction(cancelAction)
//        present(alertVC, animation: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
    }
    
    func configureCell(photoObj: Photo){
        guard let image = UIImage(data: photoObj.imageData)  else {
            return
        }
        
        photoImageView.image = image
        titleLabel.text = photoObj.photoTitle
        dateLabel.text = photoObj.date
    }
    
    
}
