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

protocol AddOrUpdatePhotoEntryDelegate: AnyObject {
    func createdPhotoEntry(_ viewController: AddPhotoEntryViewController, _ newPhotoEntry: Photo)
    func updatedPhotoEntry(_ viewController: AddPhotoEntryViewController,_ oldPhotoEntry: Photo, _ newPhotoEntry: Photo)
}

class AddPhotoEntryViewController: UIViewController {
    

    @IBOutlet weak var photoEntryTextView: UITextView!
    @IBOutlet weak var photoEntryImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    private var imagePickerController = UIImagePickerController()
    
    var passedPhotoObj:Photo?
    var selectedImage: UIImage?
    
    public private(set) var photoState = PhotoState.newPhoto
    
    weak var delegate: AddOrUpdatePhotoEntryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        delegatesAndDataSources()
        didSaveButtonBecomeAvailable()
        didCameraButtonBecomeAvailable()
        updateUI()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        showImageController(isCameraSelected: false)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        showImageController(isCameraSelected: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    private func delegatesAndDataSources(){
        photoEntryTextView.delegate = self
        imagePickerController.delegate = self
    }
    
    private func showImageController(isCameraSelected: Bool) {
        // source type default will be photo library
        imagePickerController.sourceType = .photoLibrary
        
        if isCameraSelected{
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
    
    private func didCameraButtonBecomeAvailable(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }

    }
    
    private func updateUI(){
        guard let validPhoto = passedPhotoObj else {
            fatalError("no photo was passed")
        }
        
        if photoState == .existingPhoto{
            photoEntryTextView.text = validPhoto.photoTitle
            photoEntryImageView.image = UIImage(data: validPhoto.imageData)
            saveButton.title = "Edit"
            didSaveButtonBecomeAvailable()
        }
    }
    
    private func didSaveButtonBecomeAvailable(){
        guard selectedImage == nil && photoEntryTextView.text == nil else {
            saveButton.isEnabled = true
            return
        }
    }
}

extension AddPhotoEntryViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch photoState{
        case .existingPhoto:
            break
        case .newPhoto:
            if textView.text == "Enter photo description" && textView.textColor == .lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        didSaveButtonBecomeAvailable()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch photoState{
        case .existingPhoto:
            break
        case .newPhoto:
            if textView.text == "" && textView.textColor == UIColor.black {
                textView.text = "Enter photo description"
                textView.textColor = UIColor.lightGray
            }
        }
    }
}

extension AddPhotoEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return  }
        
        selectedImage = image
        photoEntryImageView.image = selectedImage
        didSaveButtonBecomeAvailable()
    }
}

extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
