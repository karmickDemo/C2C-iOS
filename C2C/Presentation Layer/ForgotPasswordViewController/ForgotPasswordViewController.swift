//
//  ForgotPasswordViewController.swift
//  C2C
//
//  Created by Karmick on 30/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import TTGSnackbar
import Alamofire

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var btn_forgotPwd: UIButton!
    @IBOutlet var tblvw_ForgotPassword: UITableView!
    @IBOutlet var vw_Email: UIView!
    @IBOutlet var txtfld_EnterEmailAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarView?.backgroundColor = headerColor
        self.btn_forgotPwd.layer.borderWidth = 1
        self.btn_forgotPwd.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
        self.btn_forgotPwd.layer.cornerRadius = 20
        self.btn_forgotPwd.clipsToBounds = true;
        self.vw_Email.layer.borderWidth = 1
        self.vw_Email.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
        self.vw_Email.layer.cornerRadius = 20
        self.vw_Email.clipsToBounds = true
        
        self.txtfld_EnterEmailAddress.delegate = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
 
    @IBAction func btn_Back_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btn_requestForgotPassword_Click(_ sender: Any) {
        self.txtfld_EnterEmailAddress.resignFirstResponder()

        if (self.txtfld_EnterEmailAddress.text?.isEmail()) == false {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please enter a valid email", duration: TTGSnackbarDuration.middle)
        }else {
            self.forgotPwdUrlFire()
        }
    }
    
    private func forgotPwdUrlFire() {
        
        let parameter: Parameters = [
            "email": self.txtfld_EnterEmailAddress.text!,
        ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.forgotPasswordURL, withParameters: parameter, withSuccess: { (response) in
            if response is [String: Any] {
                
                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool
                
                if success == true{
                    
                    self.txtfld_EnterEmailAddress.text! = ""
                    
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Successful", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show, selected: { (_, _) in })
                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show, selected: { (_, _) in })
                }
            }
        }) { (error) in
            print ("error \((String(describing: error!.localizedDescription)))")
            
            PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: (String(describing: error!.localizedDescription)), okBtnTitle: "OK", activityType: .show, selected: { (_, _) in })
        }
    }
    
    @IBAction func btn_Login_Click(_ sender: Any) {
        let loginVC = instantiateViewController(storyboardID: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
}
