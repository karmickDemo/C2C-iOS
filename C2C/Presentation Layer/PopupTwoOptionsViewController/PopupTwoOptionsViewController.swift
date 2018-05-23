//
//  PopupTwoOptionsViewController.swift
//  C2C
//
//  Created by Karmick on 13/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Alamofire

enum PopupTypeOptions {
    case logout
    case notLogedin
    case removeWishlist
}

class PopupTwoOptionsViewController: UIViewController {

    @IBOutlet var alertLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var alphaView: UIView!
    
    var purpose: String = ""
    var viewController: UIViewController?
    
    var popupTypeOptions: PopupTypeOptions!
    var cellTag: Int?
    
    
    var didSelectOption: ((_ value: String?, _ index: Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
        
        self.cancelBtn.layer.cornerRadius = 4.0
        self.cancelBtn.clipsToBounds = true
        
        self.okBtn.layer.cornerRadius = 4.0
        self.okBtn.clipsToBounds = true
        
        self.containerView.layer.cornerRadius = 15.0
        self.containerView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.alphaView.addGestureRecognizer(tap)
        self.alphaView.isUserInteractionEnabled = true
        
        
        self.alphaView.alpha = 0
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.cancelPopup()
    }
    
    static func showPopUpTwoOptions(onParentViewController parentViewController: UIViewController, alertText: String, descriptionText: String, cancelBtnTitle: String, okBtnTitle: String, activityType: PopupTypeOptions, requiredTag: Int, selected: @escaping (_ value: String?, _ index: Int?) -> Void) {
        
        let classObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupTwoOptionsViewController") as! PopupTwoOptionsViewController
        classObj.popupConfig(onParentViewController: parentViewController, alertText: alertText, descriptionText: descriptionText, cancelBtnTitle: cancelBtnTitle, okBtnTitle: okBtnTitle, tag: requiredTag)
        classObj.didSelectOption = selected
        classObj.popupTypeOptions = activityType
    }
    
    func popupConfig(onParentViewController parentViewController: UIViewController, alertText: String, descriptionText: String, cancelBtnTitle: String, okBtnTitle: String, tag: Int) -> Void {
        
        
        self.view.frame = UIScreen.main.bounds
        UIApplication.shared.windows.first!.addSubview(self.view)
        parentViewController.addChildViewController(self)
        self.didMove(toParentViewController: parentViewController)
        parentViewController.view.bringSubview(toFront: self.view)
        
        viewController = parentViewController
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.alphaView.alpha = 0.7
            self.containerView.transform = .identity
        }) { _ in
            
        }
        
        self.alertLbl.text = alertText
        self.descriptionLbl.text = descriptionText
        
        self.cancelBtn.setTitle(cancelBtnTitle, for: .normal)
        self.okBtn.setTitle(okBtnTitle, for: .normal)
        
        self.cellTag = tag
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.cancelPopup()
    }
    
    func cancelPopup() -> Void {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            self.alphaView.alpha = 0
        }) { (_) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    private func logout() {
        
        let user_id: Int =  UserDefaults.standard.integer(forKey: "user_id")
        
        let parameter: Parameters = [
            "user_id": String(user_id),
            "type": "iOS"
        ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.logoutURL, withParameters: parameter, withSuccess: { (response) in
            
            if response is [String: Any] {
                
                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool
                
                if success == true {
                    
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
                        
                    self.pushToLogin()
                    
                } else {
                    
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
                    
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show, selected: { (_, _) in })
                }
            }
            
        }) { (error) in
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
            PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: error!.localizedDescription, okBtnTitle: "OK", activityType: .show, selected: { (_, _) in })
        }
    }
    
    @IBAction func okBtnAction(_ sender: Any) {
        
        switch popupTypeOptions {
            
        case .logout:
            
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
                self.alphaView.alpha = 0
            }) { (_) in
                self.logout()
            }
            
            break
        case .notLogedin:
            
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
                self.alphaView.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                
                self.pushToLogin()
            }
            break
        case .removeWishlist:
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
                self.alphaView.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                self.didSelectOption!("remove", self.cellTag)
            }
            break
        default: break
        }
    }
    
    func pushToLogin() -> Void {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        viewController!.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
