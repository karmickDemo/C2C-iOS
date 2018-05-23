//
//  LoginViewController.swift
//  C2C
//
//  Created by Karmick on 04/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FacebookShare
import ANLoader
import Alamofire
import TTGSnackbar

class LoginViewController: UIViewController {

    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    
    @IBOutlet var staySignInBtn: UIButton!
    @IBOutlet var showPasswordBtn: UIButton!
    
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    
    @IBOutlet var viewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var loginTableView: UITableView!
    
    var loginData: Login?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (Device.IS_IPHONE_5) {
            
            print("iphone 5")
            self.viewTopConstraint.constant = 162
            
        } else {
            
            self.viewTopConstraint.constant = 200
        }
        
        self.loginTableView.isScrollEnabled = false
        
        self.emailView.layer.borderWidth = 1
        self.emailView.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
        self.emailView.layer.cornerRadius = 20
        self.emailView.clipsToBounds = true;
        
        self.passwordView.layer.borderWidth = 1
        self.passwordView.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
        self.passwordView.layer.cornerRadius = 20
        self.passwordView.clipsToBounds = true
        
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.borderColor = UIColor(red:26/255, green:26/255, blue:26/255, alpha: 1).cgColor
        self.loginBtn.layer.cornerRadius = 22.5
        self.loginBtn.clipsToBounds = true;
        
        self.registerBtn.layer.cornerRadius = 22.5
        self.registerBtn.clipsToBounds = true;
        
        self.emailTxt.textContentType = UITextContentType("")
        self.passwordTxt.textContentType = UITextContentType("")
        
        UserDefaults.standard.set("signedoff", forKey: "signIn")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Social login
    
    @IBAction func btn_Twitter_Login_Clicked(_ sender: Any) {
    }
    
    @IBAction func btn_FaceBook_Login_Clicked(_ sender: Any) {
    }
    
    
    // MARK: - Button action
    
    @IBAction func staySignInAction(_ sender: Any) {
        
        if self.staySignInBtn.isSelected == true
        {
            self.staySignInBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
            self.staySignInBtn.isSelected = false
            
            UserDefaults.standard.set("signedoff", forKey: "signIn")
        }
        else
        {
            self.staySignInBtn.setImage(UIImage(named: "check"), for: UIControlState.selected)
            self.staySignInBtn.isSelected = true
            
            UserDefaults.standard.set("signedIn", forKey: "signIn")
        }
    }
    
    @IBAction func showPasswprdAction(_ sender: Any) {
        if self.showPasswordBtn.isSelected == true
        {
            self.showPasswordBtn.setImage(UIImage(named: "passwordVisible"), for: UIControlState.normal)
            self.passwordTxt.isSecureTextEntry = true
            self.showPasswordBtn.isSelected = false
        }
        else
        {
            self.showPasswordBtn.setImage(UIImage(named: "passwordNotVisible"), for: UIControlState.selected)
            self.passwordTxt.isSecureTextEntry = false
            self.showPasswordBtn.isSelected = true
        }
    }
   
    @IBAction func btn_Login_Clicked(_ sender: Any)
    {
        
        if (self.emailTxt.text!.isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Email field can not be blank", duration: TTGSnackbarDuration.middle)
        } else if (self.emailTxt.text?.isEmail()) == false {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please enter a valid email", duration: TTGSnackbarDuration.middle)
        } else if (self.emailTxt.text!.isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Password field can not be blank", duration: TTGSnackbarDuration.middle)
        } else {
            self.view.endEditing(true)
            self.submitLoginAction()
        }
    }
 
    @IBAction func btn_Register_Clicked(_ sender: Any)
    {
        let mRegistrationBuyerViewController = instantiateViewController(storyboardID: "RegistrationBuyerViewController") as! RegistrationBuyerViewController
        
        self.navigationController?.pushViewController(mRegistrationBuyerViewController, animated: false)
    }
    
    @IBAction func btn_LoginAs_aGuest(_ sender: Any) {
        
    }
    
    @IBAction func btn_ForgotPassword_Click(_ sender: Any) {
        let forgotVC = instantiateViewController(storyboardID: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated: false)
    }
    
}

// MARK: - TextField Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.loginTableView.isScrollEnabled = false
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.loginTableView.isScrollEnabled = true
        return true;
    }
}

// MARK: - API Calling

private typealias apiMethods = LoginViewController
extension apiMethods {
    
    func submitLoginAction() -> Void {
        
        let app = UIApplication.shared.delegate as! AppDelegate
        
        var deviceToken: String = ""
        
        if let token = app.deviceTokenString {
            deviceToken = token
        }
        
        let parameters : Parameters = [
            "email": self.emailTxt.text!,
            "password": self.passwordTxt!.text!,
            "device_id": deviceToken,
            "device_type": "iOS",
            ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.loginURL, withParameters: parameters, withSuccess: { (response) in
            
            if response is [String: Any] {
                
                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool
                
                if success == true{
                    
                    self.loginData = Login(JSON: Main_response)
                    
                    print(self.loginData!.data[0].user_type!)
                    
                    if self.loginData!.data[0].user_type! == "1" {
                        UserDefaults.standard.set("Buyer", forKey: "PageType")
                    } else if self.loginData!.data[0].user_type! == "2" {
                        UserDefaults.standard.set("Seller", forKey: "PageType")
                    }
                    
                    UserDefaults.standard.set(self.loginData!.data[0].id!, forKey: "user_id")
                    UserDefaults.standard.set(self.loginData!.data[0].user_type!, forKey: "user_type")
                    
                    let mDashBoardViewController = instantiateViewController(storyboardID: "DashBoardViewController") as! DashBoardViewController
                    
                    self.navigationController?.pushViewController(mDashBoardViewController, animated: true)
                    
                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show, selected: { (_, _) in })
                }
            }
        }) { (error) in
            print ("error \((String(describing: error!.localizedDescription)))")
            
            PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: (String(describing: error!.localizedDescription)), okBtnTitle: "OK", activityType: .show, selected: { (_, _) in })
        }
    }
}





