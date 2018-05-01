//
//  ForgotPasswordViewController.swift
//  C2C
//
//  Created by Karmick on 30/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import TTGSnackbar

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var btn_forgotPwd: UIButton!
    @IBOutlet var tblvw_ForgotPassword: UITableView!
    @IBOutlet var vw_Email: UIView!
    @IBOutlet var txtfld_EnterEmailAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("hello world")
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
        }else{
            
        }
    }
    
    @IBAction func btn_Login_Click(_ sender: Any) {
        let loginVC = instantiateViewController(storyboardID: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
}
