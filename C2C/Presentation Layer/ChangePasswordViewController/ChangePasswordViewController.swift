//
//  ChangePasswordViewController.swift
//  C2C
//
//  Created by Karmick on 25/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import TTGSnackbar
import Alamofire

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.becomeFirstResponder()
    }

    
}

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet var tblvw_ChangePassword: UITableView!
    
    @IBOutlet var vw1: UIView!
    @IBOutlet var vw3: UIView!
    @IBOutlet var vw2: UIView!
    
    @IBOutlet var txtfld_OldPassword: UITextField!
    @IBOutlet var txtfld_NewConfirmPassword: UITextField!
    @IBOutlet var txtfld_NewPassword: UITextField!
    
    @IBOutlet var btn_menu: UIButton!
    @IBOutlet var btn_update: UIButton!
    var user_id: Int?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tblvw_ChangePassword.alwaysBounceVertical = false
        
        print("Hello World")
        
        self.vw1.layer.borderWidth = 1
        self.vw1.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
        self.vw1.layer.cornerRadius = 20
        self.vw1.clipsToBounds = true;
        self.vw2.layer.borderWidth = 1
        self.vw2.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
        self.vw2.layer.cornerRadius = 20
        self.vw2.clipsToBounds = true;
        self.vw3.layer.borderWidth = 1
        self.vw3.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
        self.vw3.layer.cornerRadius = 20
        self.vw3.clipsToBounds = true;
        self.btn_update.layer.borderWidth = 1
        self.btn_update.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
        self.btn_update.layer.cornerRadius = 20
        self.btn_update.clipsToBounds = true;
        
        self.txtfld_NewPassword.delegate = self
        self.txtfld_OldPassword.delegate = self
        self.txtfld_NewConfirmPassword.delegate = self
        user_id =  UserDefaults.standard.integer(forKey: "user_id")
        print(user_id)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_Update_Click(_ sender: Any) {
        if (self.txtfld_OldPassword.text!.isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please enter your old password", duration: TTGSnackbarDuration.middle)
        } else if (self.txtfld_NewPassword.text!.isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please enter your new password", duration: TTGSnackbarDuration.middle)
        } else if (self.txtfld_NewConfirmPassword.text!.isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please enter your confirm password", duration: TTGSnackbarDuration.middle)
        }
        else if !(self.txtfld_NewPassword.text == self.txtfld_NewConfirmPassword.text) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "New and confirm password should be Same", duration: TTGSnackbarDuration.middle)
        }else {
            self.view.endEditing(true)
            self.updatePasswordUrlFire()
        }
    }
    
    @IBAction func btn_menu_Click(_ sender: Any) {
        self.view.endEditing(true)
        LeftMenuViewController.showLeftMenu(onParentViewController: self) { (_, _) in
            
        }
    }
    
    private func updatePasswordUrlFire () {
        
        let parameters : Parameters = [
            "user_id": String(user_id!),
            "pass_old": self.txtfld_OldPassword!.text!,
            "pass_new": self.txtfld_NewPassword!.text!,
            ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.changePasswordURL, withParameters: parameters, withSuccess: { (response) in
            
            if response is [String: Any] {
                print("From login")
                print(response);
                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool
                
                if success == true{
                    print("response chngpsw--\(Main_response)")
                    
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Successful", descriptionText: "Password changed successfully", okBtnTitle: "OK", activityType: .show)
                    
                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
                }
            }
        }) { (error) in
            print ("error \((String(describing: error!.localizedDescription)))")
            
        }
    }
}

