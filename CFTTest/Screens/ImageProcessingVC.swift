//
//  ImageProcessingVC.swift
//  CFTTest
//
//  Created by Денис Лебедько on 05/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit
import AVFoundation

class ImageProcessingVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var rotateButton: RoundedButton!
    @IBOutlet weak var invertColorsButton: RoundedButton!
    @IBOutlet weak var mirrorImageButton: RoundedButton!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    let imagePicker = UIImagePickerController()
    var tableViewAdapter: ImageProcessingTVAdapter!
    private var imageStorage: FileStorage = FileStorage()
    var activeTransformators: [ImageTransformator] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        tableViewAdapter = ImageProcessingTVAdapter(tableView)
        tableViewAdapter.showActionsBlock = { image in
            let addToLibraryAction = UIAlertAction(title: NSLocalizedString("selectActionAlert.action.addToLibrary", comment: ""), style: .default, handler: { _ in
                self.saveImageToAlbum(image)
            })
            let deleteImageAction = UIAlertAction(title: NSLocalizedString("selectActionAlert.action.deleteImage", comment: ""), style: .default, handler: { _ in
                self.deleteImage(image)
            })
            let useAsSourceAction = UIAlertAction(title: NSLocalizedString("selectActionAlert.action.useAsSource", comment: ""), style: .default, handler: { _ in
                self.useImageAsSource(image)
            })
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
            self.showAlert(title: NSLocalizedString("selectImageSourceAlert.title", comment: ""), message: nil, actions: [addToLibraryAction, deleteImageAction, useAsSourceAction, cancelAction])
        }
        
        let names = defaults.stringArray(forKey: Constants.transformedImageNamesKey) ?? [String]()
        tableViewAdapter.transformedImages = imageStorage.getImagesFromFiles(imageNames: names)
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let cameraAction = UIAlertAction(title: NSLocalizedString("selectImageSourceAlert.action.camera", comment: ""), style: .default, handler: { _ in
            self.openCamera()
        })
        
       let libraryAction = UIAlertAction(title: NSLocalizedString("selectImageSourceAlert.action.photoLibrary", comment: ""), style: .default, handler: { _ in
            self.openLibrary()
        })
        let cancelAction = UIAlertAction.init(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        
        showAlert(title: NSLocalizedString("selectImageSourceAlert.title", comment: ""), message: nil, actions: [cameraAction, libraryAction, cancelAction])
    }
    
    @IBAction func rotate() {
        let transformator = RotateImageTransformator()
        activeTransformators.append(transformator)
        transformImage(transformator)
    }
    
    @IBAction func invertColors() {
        let transformator = InvertColorsImageTransformator()
        activeTransformators.append(transformator)
        transformImage(transformator)
    }
    
    @IBAction func mirrorImage() {
        let transformator = MirrorImageTransformator()
        activeTransformators.append(transformator)
        transformImage(transformator)
    }
    
    func transformImage(_ transformator: ImageTransformator) {
        guard let image = imageView.image else {
            return
        }
        
        let loadingItem = LoadingItem()
        self.tableViewAdapter.loadingItems.append(loadingItem)

        transformator.transform(image, progressBlock: { (progress) in
            loadingItem.currentProgress = progress
        }) { (newImage) in
            self.tableViewAdapter.loadingItems =
                self.tableViewAdapter.loadingItems.filter { $0 != loadingItem }
            
            let storage = FileStorage()
            let uuid = storage.saveImageToFile(image: newImage)
            let transformedImage = TransformedImage(image: newImage, uuid: uuid)
            self.tableViewAdapter.transformedImages.append(transformedImage)
            
            self.activeTransformators.remove(object: transformator)
        }
    }
    
    func saveImageToAlbum(_ transformedImage: TransformedImage) {
        UIImageWriteToSavedPhotosAlbum(transformedImage.image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func deleteImage(_ transformedImage: TransformedImage) {
        tableViewAdapter.transformedImages = tableViewAdapter.transformedImages.filter { $0 != transformedImage }
        imageStorage.removeImageFromFiles(imageName: transformedImage.uuid)
    }
    
    func useImageAsSource(_ transformedImage: TransformedImage) {
        imageView.image = transformedImage.image
    }
}

extension ImageProcessingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            showAlert(title: NSLocalizedString("error.openCameraAlert.title", comment: ""), message: NSLocalizedString("error.openCameraAlert.message", comment: ""), actions: [UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)])
        }
    }
    
    func openLibrary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: NSLocalizedString("saveImageAlert.error.title", comment: ""), message: error.localizedDescription, actions: [UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)])
        } else {
            showAlert(title: NSLocalizedString("saveImageAlert.success.title", comment: ""), message: nil, actions: [UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)])
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let tempImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image  = tempImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

