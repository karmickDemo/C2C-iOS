//
//  imagePickerHelper.swift
//  AdvancedPT
//
//  Created by new on 08/03/18.
//  Copyright © 2018 Anirban. All rights reserved.
//

import UIKit
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

class imagePickerHelper: NSObject {
    
    override init() {}
    
    var chosenImage: UIImage?
    var getimage: ((_ selectedItem: UIImage ,_ selectedvalue: Bool) -> Void)?
    static let helper = imagePickerHelper()
    var viewcontroller = UIViewController()
    
    func opencamera (withParentViewController ParentViewController: UIViewController,source: UIImagePickerControllerSourceType,selectedimage: @escaping (_ value: UIImage?,_ selectedvalue: Bool?) -> Void){
        
        let picker = UIImagePickerController()
        viewcontroller = ParentViewController
        picker.delegate = self
        picker.sourceType = source
        
        //        if picker.sourceType == UIImagePickerControllerSourceType.camera
        //        {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            viewcontroller.present(picker,animated: true,completion: nil)
            getimage = selectedimage
        }
        else{
            
            noCamera()
        }
        
        //        }
        //        else{
        //            picker.allowsEditing = false
        //            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //            viewcontroller.present(picker,animated: true,completion: nil)
        //            getimage = selectedimage
        //
        //        }
        
        
    }
    
    func showlibarary(onParentViewController parentViewController: UIViewController, source: UIImagePickerControllerSourceType, didSelectImage:@escaping (_ value: UIImage?,_ selectedvalue: Bool?) -> Void) {
        viewcontroller = parentViewController
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        //   picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        getimage = didSelectImage
        
        parentViewController.present(picker, animated: true,completion: nil)
        
    }
    
    
    
    func noCamera() {
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alertVC.addAction(okAction)
        viewcontroller.present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    
    
    
}

extension imagePickerHelper: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage //2
    
        getimage!(chosenImage!,true)
//        if let imageData = chosenImage?.jpeg(.lowest) {
//            print(imageData.count)
//        }
        viewcontroller.dismiss(animated: true, completion: nil) //5
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewcontroller.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
}

