//
//  AddPhotoEntryViewController.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import AVFoundation

enum PhotoState{
    case newPhoto
    case existingPhoto
}

protocol AddOrUpdatePhotoEntryDelegate: AnyObject {
    func createOrUpdatePhotoEntry(_ newPhotoEntry: Photo, editedPhotoIndex: IndexPath?, photoState: PhotoState)
}

class AddPhotoEntryViewController: UIViewController {
    

    @IBOutlet weak var photoEntryTextView: UITextView!
    @IBOutlet weak var photoEntryImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    private var imagePickerController = UIImagePickerController()
    
    var passedPhotoObj:Photo?
    var selectedImage: UIImage?
    
    var selectedIndexAsInt:IndexPath?
    
    private var dataPersistance = PersistanceHelper(filename: "PhotoJournalData.plist")
    
    public private(set) var photoState = PhotoState.newPhoto
    
    weak var delegate: AddOrUpdatePhotoEntryDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        delegatesAndDataSources()
        //didSaveButtonBecomeAvailable()
        didCameraButtonBecomeAvailable()
        uiOnLoad()
    }
    
    func returnPhotoEntry() -> Photo?{
//        guard let validSelectedImage = selectedImage else {
//            print("No image selected")
//            return nil
//        }
        
        guard let validImageFromUI = photoEntryImageView.image else{
            print("No image on uiimage element")
            return nil
        }
        
        let screenSize = UIScreen.main.bounds.size
        let aspectRatioRect = AVMakeRect(aspectRatio: validImageFromUI.size, insideRect: CGRect(origin: CGPoint.zero, size: screenSize))
        let resizedImage = validImageFromUI.resizeImage(to: aspectRatioRect.size.width, height: aspectRatioRect.size.height)
        guard let resizedImageData = resizedImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        let photoEntry = Photo(imageData: resizedImageData, photoTitle: photoEntryTextView.text, date: Date().description(with: .current))
        return photoEntry
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let newPhotoEntry = returnPhotoEntry() else {
            return
        }
        
        print("Photo Title", newPhotoEntry.photoTitle)
        
        guard let collectionVC = storyboard?.instantiateViewController(identifier: "CollectionViewController") as? CollectionViewController else {
            fatalError("failed to downcast to AddPhotoEntryViewController")
        }
        

        switch photoState {
        case .newPhoto:
            do {
                try dataPersistance.create(photoObj: newPhotoEntry)
                delegate.createOrUpdatePhotoEntry(newPhotoEntry, editedPhotoIndex: nil, photoState: photoState)
            } catch {
                showAlert(title: "Failed to create", message: "\(error)")
            }
            
            dismiss(animated: true, completion: nil)
        case .existingPhoto:
            collectionVC.delegate = self
            guard let oldPhotoItem = passedPhotoObj else {
                showAlert(title: "PHOTO STATE ERROR", message: "Passed Photo Object must not be nil is photoState is existing Photo")
                fatalError("Passed Photo Object must not be nil is photoState is existing Photo")
            }
            dataPersistance.update(oldPhotoItem, newPhotoEntry)
            //delegate.createOrUpdatePhotoEntry(newPhotoEntry, editedPhotoIndex: selectedIndexAsInt!, photoState: photoState)
            
            dismiss(animated: true, completion: nil)

        }
        
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        showImageController(isCameraSelected: false)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        showImageController(isCameraSelected: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
    
    private func uiOnLoad(){
        if passedPhotoObj == nil{
            photoState = .newPhoto
            photoEntryTextView.text = "Enter photo description"
            photoEntryTextView.textColor = UIColor.lightGray
            saveButton.title = "Save"
            saveButton.isEnabled = false
            photoEntryImageView.image = UIImage(systemName: "photo")
        } else {
            photoState = .existingPhoto
            guard let validPhoto = passedPhotoObj else {
                print("no photo was passed")
                return
            }
            photoEntryTextView.text = validPhoto.photoTitle
            photoEntryTextView.textColor = .black
            photoEntryImageView.image = UIImage(data: validPhoto.imageData)
            saveButton.title = "Edit"
        }
        
    }
    
    private func updateUI(){
        saveButton.isEnabled = true
    }
    
    private func didSaveButtonBecomeAvailable(){
        
        print(selectedImage, photoEntryTextView.text)
        switch photoState {
        case .newPhoto:
            if selectedImage == nil && ((photoEntryTextView.text == "Enter photo description" || photoEntryTextView.text.isEmpty) && photoEntryTextView.textColor == UIColor.lightGray) {
                saveButton.isEnabled = false
                print("State of button should be closed", photoState)
            } else {
                updateUI()
                print("State of button should be open", photoState)
            }
//            guard selectedImage != nil && (photoEntryTextView.text != "Enter photo description" && photoEntryTextView.textColor != UIColor.lightGray) else {
//                saveButton.isEnabled = false
//                print("State of button should be closed", photoState)
//                return
//            }
//            updateUI()
//            print("State of button should be open", photoState)
        case .existingPhoto:
            
//            if (photoEntryImageView.image!.isEqualToImage(UIImage(data: passedPhotoObj!.imageData)!)) {
//                    print("works")
//            } else {
//                print("doesn't work")
//            }
            
            
            
            if (
                (photoEntryImageView.image!.isEqualToImage(UIImage(data: passedPhotoObj!.imageData)!)) &&
                photoEntryTextView.text == passedPhotoObj?.photoTitle) {
                saveButton.isEnabled = false
                
                
                //print(!(photoEntryImageView.image!.isEqualToImage(UIImage(data: passedPhotoObj!.imageData)!))  && photoEntryTextView.text != passedPhotoObj?.photoTitle)
                print("State of button should be closed", photoState)

            } else {
                updateUI()
                //print((!photoEntryImageView.image!.isEqualToImage(UIImage(data: passedPhotoObj!.imageData)!))  && photoEntryTextView.text == passedPhotoObj?.photoTitle)
                print("State of button should be open", photoState)
            }
            
        }
        
    }
}

extension AddPhotoEntryViewController: EditButtonOfCellDelegate{
    func editButtonPressed(_ cellIndex: IndexPath, photoObj: Photo) {
        
        if photoState == .existingPhoto{
            selectedIndexAsInt = cellIndex
            passedPhotoObj = photoObj
        } else if photoState == .newPhoto{
            fatalError("Add Photo Entry VC is in the wrong photoState, should be as existingPhoto")
        }
        
    }
}

extension AddPhotoEntryViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        didSaveButtonBecomeAvailable()
    }
//        switch photoState{
//        case .existingPhoto:
//            didSaveButtonBecomeAvailable()
//        case .newPhoto:
//
//            if textView.text == "Enter photo description" && textView.textColor == UIColor.lightGray {
//                textView.text = ""
//                textView.textColor = UIColor.black
//            }
//            didSaveButtonBecomeAvailable()
//        }
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        switch photoState{
        case .existingPhoto:
            didSaveButtonBecomeAvailable()
        case .newPhoto:

            if textView.text == "Enter photo description" && textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
            didSaveButtonBecomeAvailable()
        }
        //print(photoState)
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        switch photoState{
//        case .existingPhoto:
//            didSaveButtonBecomeAvailable()
//        case .newPhoto:
//            if textView.text == "" && textView.textColor == UIColor.black {
//                textView.text = "Enter photo description"
//                textView.textColor = UIColor.lightGray
//            }
//        }
//    }
}

extension AddPhotoEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return  }
        
        selectedImage = image
        photoEntryImageView.image = selectedImage
        didSaveButtonBecomeAvailable()
        dismiss(animated: true, completion: nil)
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
