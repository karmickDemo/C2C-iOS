//
//  ImagePickerViewController.swift
//  C2C
//
//  Created by Karmick on 19/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit


extension UIImagePickerController {
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
    }
}

class ImagePickerViewController: UIViewController {
    
    @IBOutlet var vw_alpha: UIView!
    
    @IBOutlet var vw_ActionsheetBckgrdVW: UIView!
    
    @IBOutlet var btn_gallery: UIButton!
    @IBOutlet var btn_camera: UIButton!
    @IBOutlet var lbl_TitlePickerImg: UILabel!
    @IBOutlet var vw_actionsheet: UIView!
    @IBOutlet var btn_Cancel: UIButton!
    var viewcontrollerr = UIViewController()
    var strType = String()
    let helper = imagePickerHelper()
    var didSelect: ((_ selectedItem: String, _ index: Int?) -> Void)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        btn_Cancel.layer.cornerRadius = 10.5
        btn_Cancel.clipsToBounds = true
        
        vw_actionsheet.layer.cornerRadius = 10.5
        vw_actionsheet.clipsToBounds = true
        
        self.vw_alpha.alpha = 0
        self.btn_Cancel.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        self.vw_actionsheet.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.vw_ActionsheetBckgrdVW.addGestureRecognizer(tap)
        self.vw_ActionsheetBckgrdVW.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        self.cancelPopup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
 static func showImagePicker(onParentViewController parentViewController: UIViewController, selected: @escaping (_ value: String?, _ index: Int?) -> Void) {
    
        let presentViewController = UIStoryboard(name: "Main", bundle: nil)
        let classObj = presentViewController.instantiateViewController(withIdentifier: "ImagePickerViewController") as! ImagePickerViewController
        classObj.didSelect = selected
        classObj.showimagePicker(onParentViewController: parentViewController)
    }
    
 func showimagePicker(onParentViewController parentViewController: UIViewController) {
        
        self.view.frame = UIScreen.main.bounds
        UIApplication.shared.windows.first!.addSubview(self.view)
        parentViewController.addChildViewController(self)
        self.didMove(toParentViewController: parentViewController)
        parentViewController.view.bringSubview(toFront: self.view)
        
        viewcontrollerr = parentViewController
        
        UIView.animate(withDuration: 0.3, animations: {
            self.btn_Cancel.transform = .identity
            self.vw_alpha.alpha = 0.7
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                
                self.vw_actionsheet.transform = .identity
            }) { _ in
                
            }
        }
    }

    @IBAction func btn_Cancel_Click(_ sender: Any) {
        self.cancelPopup()
        strType = "Cancel"
        btn_Cancel.tag = 8
         didSelect!(strType, btn_Cancel.tag)


    }
    @IBAction func btn_Gallery_click(_ sender: Any) {
        cancelPopup()
        strType = "Gallery"
        btn_gallery.tag = 9
        didSelect!(strType, btn_gallery.tag)

    }
    @IBAction func btn_Camer_Click(_ sender: Any) {
        cancelPopup()
        strType = "Camera"
        btn_gallery.tag = 9
        didSelect!(strType, btn_camera.tag)

    }
  
    private func cancelPopup() -> Void {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.vw_ActionsheetBckgrdVW.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            self.vw_alpha.alpha = 0
        }) { (_) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
   
}

