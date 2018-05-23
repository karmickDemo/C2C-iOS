//
//  PopupOneOptionViewController.swift
//  C2C
//
//  Created by Karmick on 19/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit

 enum PopupTypeNormal {
    case show
    case registrationSuccess
    case propertyAdded
    case offerAcceptReject
}

class PopupOneOptionViewController: UIViewController {
    
    @IBOutlet var alertLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var alphaView: UIView!
    
    var viewController: UIViewController?
    var purpose: String = ""
    
    var popupTypeNormal: PopupTypeNormal!
    var didSelectOption: ((_ value: String?, _ index: Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
        
        self.okBtn.layer.cornerRadius = 4.0
        self.okBtn.clipsToBounds = true
        
        self.containerView.layer.cornerRadius = 15.0
        self.containerView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.alphaView.addGestureRecognizer(tap)
        self.alphaView.isUserInteractionEnabled = true
        
        self.alphaView.alpha = 0

        // Do any additional setup after loading the view.
    }
    
    static func showPopUpOneOptions(onParentViewController parentViewController: UIViewController, alertText: String, descriptionText: String, okBtnTitle: String, activityType: PopupTypeNormal, selected: @escaping (_ value: String?, _ index: Int?) -> Void) -> Void {
        
        let classObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupOneOptionViewController") as! PopupOneOptionViewController
        classObj.popupConfig(onParentViewController: parentViewController, alertText: alertText, descriptionText: descriptionText, okBtnTitle: okBtnTitle)
        
        classObj.popupTypeNormal = activityType
        classObj.didSelectOption = selected
    }
    
    func popupConfig(onParentViewController parentViewController: UIViewController, alertText: String, descriptionText: String, okBtnTitle: String) -> Void {
        
        
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
        
        self.okBtn.setTitle(okBtnTitle, for: .normal)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
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
    
    @IBAction func okBtnAction(_ sender: Any) {
        
        switch self.popupTypeNormal {
        case .show:
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
                self.alphaView.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
            break
        case .registrationSuccess:
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
                self.alphaView.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                self.pushToLogin()
            }
            break
        case .propertyAdded:
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
                self.alphaView.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                self.popBack()
            }
            break
        case .offerAcceptReject:
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
                self.alphaView.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                self.didSelectOption!("refresh", 0)
            }
            break
        default: break
        }
    }
    
    private func popBack()  {
        viewController!.navigationController?.popViewController(animated: true)
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
