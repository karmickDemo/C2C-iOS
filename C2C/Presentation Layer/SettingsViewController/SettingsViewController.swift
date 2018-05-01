//
//  SettingsViewController.swift
//  C2C
//
//  Created by Karmick on 26/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController {

    @IBOutlet var lbl_AlertTitle: UILabel!
    @IBOutlet var btn_notification2: UIButton!
    @IBOutlet var lbl_notification: UILabel!
    @IBOutlet var btn_notification: UIButton!
    @IBOutlet var lbl_notification2: UILabel!
    @IBOutlet var tblvw_settings: UITableView!
    @IBOutlet var btn_save: UIButton!
    
    var user_id: Int?
    var settingArr = [[String:Any]]()
    var strEmailNotify = String()
    var strWeeklyNotify = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblvw_settings.alwaysBounceVertical = false
        self.user_id =  UserDefaults.standard.integer(forKey: "user_id")
        self.btn_save.layer.cornerRadius = 20
        self.btn_save.clipsToBounds = true

        self.getSettingsUrlFire()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  // MARK: - Calling from webservice
    private func getSettingsUrlFire () {
        
        let parameters : Parameters = [
           "user_id": String(user_id!),
            ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.getSettingsURL, withParameters: parameters, withSuccess: { (response) in
            
            if response is [String: Any] {
                
                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool
                
                if success == true{
                    
                    self.settingArr = Main_response["settings"] as! [[String: Any]]
                   // print("self.settingArr=\(self.settingArr)")
                    
                    if (self.settingArr[0]["new_property_email_notify"] as! String) == "1"{
                        self.btn_notification.setImage(UIImage(named: "check"), for: UIControlState.selected)
                        self.btn_notification.isSelected = true
                        UserDefaults.standard.set((self.settingArr[0]["new_property_email_notify"] as! String), forKey: "emailNotify")
                        self.strEmailNotify = self.settingArr[0]["new_property_email_notify"] as! String
                    }else{
                        self.btn_notification.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
                        self.btn_notification.isSelected = false
                        UserDefaults.standard.set((self.settingArr[0]["new_property_email_notify"] as! String), forKey: "emailNotify")
                        self.strEmailNotify = self.settingArr[0]["new_property_email_notify"] as! String
                    }
                    
                    if (self.settingArr[0]["weekly_email_notify"] as! String) == "1"{
                        self.btn_notification2.setImage(UIImage(named: "check"), for: UIControlState.selected)
                        self.btn_notification2.isSelected = true
                        UserDefaults.standard.set((self.settingArr[0]["weekly_email_notify"] as! String), forKey: "weekly")
                        self.strWeeklyNotify = self.settingArr[0]["weekly_email_notify"] as! String
                    }else{
                        self.btn_notification2.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
                        self.btn_notification2.isSelected = false
                        UserDefaults.standard.set((self.settingArr[0]["weekly_email_notify"] as! String), forKey: "weekly")
                        self.strWeeklyNotify = self.settingArr[0]["weekly_email_notify"] as! String
                    }                    
                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
                }
            }
        }) { (error) in
            print ("error \((String(describing: error!.localizedDescription)))")
            
        }
    }
    
    @IBAction func btn_NotificationClick(_ sender: Any) {
        if self.btn_notification.isSelected == true{
            self.btn_notification.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
            self.btn_notification.isSelected = false
            self.strEmailNotify = "0"
        }else{
            self.btn_notification.setImage(UIImage(named: "check"), for: UIControlState.selected)
            self.btn_notification.isSelected = true
            self.strEmailNotify = "1"
        }
    }
  
    @IBAction func btn_Menu_Click(_ sender: Any) {
        self.view.endEditing(true)
        LeftMenuViewController.showLeftMenu(onParentViewController: self) { (_, _) in
        }
    }
    
    @IBAction func btn_Notification2Click(_ sender: Any) {
        if self.btn_notification2.isSelected == true {
            self.btn_notification2.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
            self.btn_notification2.isSelected = false
            self.strWeeklyNotify = "0"
        }else{
            self.btn_notification2.setImage(UIImage(named: "check"), for: UIControlState.selected)
            self.btn_notification2.isSelected = true
            self.strWeeklyNotify = "1"
        }
    }
    
    @IBAction func btn_save_Click(_ sender: Any) {
            let parameters : Parameters = [
                "user_id": String(user_id!),
                "weekly_mail": self.strWeeklyNotify,
                "property_mail": self.strEmailNotify,
                ]
            ApiCallingClass.BaseApiCalling(withurlString: URLs.updateSettingsURL, withParameters: parameters, withSuccess: { (response) in
                if response is [String: Any] {
                   // print(response)
                    let Main_response = response as! [String: Any]
                    let success = Main_response["success"] as! Bool
                    
                    if success == true{
                        PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "successful", descriptionText: "Setting updated.", okBtnTitle: "OK", activityType: .show)

                    } else {
                        PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
                    }
                }
            }) { (error) in
                print ("error \((String(describing: error!.localizedDescription)))")
            }
    }
}
