//
//  SetPreferencesViewController.swift
//  C2C
//
//  Created by Karmick on 26/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SetPreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPreferenceContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if arrPreferenceContent[indexPath.row]["type"] as! String == "dropdown" {
            let cellDropDown = tableView.dequeueReusableCell(withIdentifier: "textFieldCellDropDown", for: indexPath) as! TextFieldCellDropDown
            
            cellDropDown.containerView.layer.borderWidth = 1
            cellDropDown.containerView.layer.borderColor = placeHolderColor.cgColor
            cellDropDown.containerView.layer.cornerRadius = 20
            cellDropDown.containerView.clipsToBounds = true
            cellDropDown.textField.tag = indexPath.row
            
            cellDropDown.textField!.placeholder = arrPreferenceContent[indexPath.row]["placeholderText"] as? String
            cellDropDown.textField!.text = arrPreferenceContent[indexPath.row]["text"] as? String
            
            cellDropDown.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cellDropDown
//        } else {
//            let cell = UITableViewCell()
//            return cell
//        }
        
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
        
    }
    
}

class SetPreferencesViewController: UIViewController {

    @IBOutlet var tblvw_Preference: UITableView!
    @IBOutlet var btn_submit: UIButton!
    @IBOutlet var backBtn: UIButton!
    
    var arrPreferenceContent = [[String:Any]]()
    var countryArr = [[String:Any]]()
    var propertyArr = [[String:Any]]()
    var loanArr = [[String:Any]]()
    var user_id: Int?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblvw_Preference.isHidden = true
        
        let dic1 = [
            "placeholderText": "Location",
            "text": "",
            "selectedIndex": "0",
            "image": "location_detail",
            "type": "dropdown",
            ]
        let dic2 = [
            "placeholderText": "Property/Business",
            "text": "",
            "selectedIndex": "0",
            "image": "property",
            "type": "dropdown",
            ]
        let dic3 = [
            "placeholderText": "Financial Loan",
            "text": "",
            "selectedIndex": "0",
            "image": "doller",
            "type": "dropdown",
            ]
     
        arrPreferenceContent = [dic1, dic2, dic3]
        
        user_id =  UserDefaults.standard.integer(forKey: "user_id")
        
        self.btn_submit.layer.cornerRadius=20
        self.btn_submit.clipsToBounds = true

        self.getPreferencesUrlFire()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton actions
    @IBAction func btn_Back_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)

    }
    
    
    @IBAction func btn_Submit_Click(_ sender: Any) {
        self.submitPreferenceProperties()
    }
    
    private func submitPreferenceProperties () {
        
        var countryIdStr = String()
        var propertyTypeStr = String()
        var loanTypeStr = String()
        
        if (arrPreferenceContent[0]["text"] as! String).isEmpty {
            countryIdStr = ""
        } else {
            countryIdStr = propertyArr[Int(arrPreferenceContent[0]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        if (arrPreferenceContent[1]["text"] as! String).isEmpty {
            propertyTypeStr = ""
        } else {
            propertyTypeStr = countryArr[Int(arrPreferenceContent[1]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        if (arrPreferenceContent[2]["text"] as! String).isEmpty {
            loanTypeStr = ""
        } else {
            loanTypeStr = loanArr[Int(arrPreferenceContent[2]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        
        let parameters : Parameters = [
            "user_id": String(user_id!),
            "country": countryIdStr,
            "property_id": propertyTypeStr,
            "loan_type_id": loanTypeStr,
        ]

        ApiCallingClass.BaseApiCalling(withurlString: URLs.updatePreferenceURL, withParameters: parameters, withSuccess: { (response) in

            if response is [String: Any] {
                
                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool

                if success == true{
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Successful", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
                }
            }

        }) { (error) in
            
            PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: (String(describing: error!.localizedDescription)), okBtnTitle: "OK", activityType: .show)
            
            print ("error \((String(describing: error!.localizedDescription)))")

        }
    }

    
    // MARK: - Popup delegates Methods
    private func doneEditing(tag: Int, str: String, indexDropDown: Int) -> Void{
        
        var chunk = [String: Any]()
        chunk = arrPreferenceContent[tag]
        
        if self.arrPreferenceContent[tag]["type"] as! String == "dropdown" {
            chunk["selectedIndex"] = String(indexDropDown)
            chunk["text"] = str
            arrPreferenceContent[tag] = chunk
            self.tblvw_Preference.reloadRows(at: [IndexPath(row: tag, section:0)], with: .none)
        } else {
            chunk["text"] = str
            arrPreferenceContent[tag] = chunk
        }
        
        print("CONTENT array==\(arrPreferenceContent)")
    }
    
    func callPopup(tag: Int) -> Void {
        
        let selectedIndex = arrPreferenceContent[tag]["selectedIndex"] as! String
        let headingName = arrPreferenceContent[tag]["placeholderText"] as! String
        
        var arr = [[String: Any]]()
        
        if headingName == "Property/Business" {
            arr = self.propertyArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .creditType) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        } else if headingName == "Location" {
            arr = self.countryArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .country) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        } else if headingName == "Financial Loan" {
            arr = self.loanArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .loanType) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        }
    }
    
    func keyboardDown() -> Void {
        
        self.view.layoutIfNeeded()
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
    }
    
    private func getPreferencesUrlFire () {
        
        let parameters : Parameters = [
            "user_id": String(user_id!),
            ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.getPrefferencesURL, withParameters: parameters, withSuccess: { (response) in
            
            if response is [String: Any] {
                
                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool
                
                if success == true {
                    
                    var prefListDic = [String: Any]()
                    var preSettings = [[String: Any]]()
                    
                    prefListDic = Main_response["preflist"] as! [String: Any]
                    self.countryArr = prefListDic["counties"] as! [[String: Any]]
                    self.propertyArr = prefListDic["property_types"] as! [[String: Any]]
                    self.loanArr = prefListDic["loantype"] as! [[String: Any]]
                    preSettings = prefListDic["presettings"] as! [[String: Any]]
                    
                    var country_id: String?
                    var property_type_ids: String?
                    var financial_loan_type_id: String?
                    
                    if preSettings.count > 0 {
                        country_id = preSettings[0]["country_ids"] as? String
                        property_type_ids = preSettings[0]["property_type_ids"] as? String
                        financial_loan_type_id = preSettings[0]["financial_loan_type_id"] as? String
                    }
                    
                    self.updatePreference(baseArr: &self.arrPreferenceContent, subArr: self.countryArr, baseArrIndex: 0, keyName: "name", checkId: country_id!)
                    self.updatePreference(baseArr: &self.arrPreferenceContent, subArr: self.propertyArr, baseArrIndex: 1, keyName: "type_name", checkId: property_type_ids!)
                    self.updatePreference(baseArr: &self.arrPreferenceContent, subArr: self.loanArr, baseArrIndex: 2, keyName: "type_name", checkId: financial_loan_type_id!)
                    
                    self.tblvw_Preference.delegate = self
                    self.tblvw_Preference.dataSource = self
                    
                    self.tblvw_Preference.reloadData()
                    
                    self.tblvw_Preference.isHidden = false
                    
                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
                }
            }
        }) { (error) in
            print ("error \((String(describing: error!.localizedDescription)))")
            
            PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: (String(describing: error!.localizedDescription)), okBtnTitle: "OK", activityType: .show)
        }
    }
    
    func updatePreference(baseArr arr1: inout [[String: Any]], subArr arr2: [[String: Any]], baseArrIndex index: Int, keyName key: String, checkId id: String) -> Void {
        
        for i in 0..<arr2.count {
            
            let chunk = arr2[i]
            if chunk["id"] as! String == id {
                
                var chunkContent = [String: Any]()
                
                chunkContent = arr1[index]
                chunkContent["text"] = chunk[key]
                chunkContent["selectedIndex"] = String(i)
                
                arr1.remove(at: index)
                arr1.insert(chunkContent, at: index)
            }
        }
    }

}

extension SetPreferencesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let updatedString = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        
        self.doneEditing(tag: textField.tag, str: updatedString, indexDropDown: 0)
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if arrPreferenceContent[textField.tag]["type"] as! String == "dropdown" {
            
            self.keyboardDown()
            
            if arrPreferenceContent[textField.tag]["placeholderText"] as! String == "Property/Business" {
                
                if propertyArr.count == 0 {
                    ApiCallingClass.BaseApiCallingGetMethod(withurlString: URLs.propertyTypeURL, withSuccess: { (response) in
                        
                        if response is [String: Any] {
                            print("From login")
                            print(response);
                            let mainResponse = response as! [String: Any]
                            let success = mainResponse["success"] as! Bool
                            
                            if success == true {
                                self.propertyArr = mainResponse["data"] as! [[String: Any]]
                                self.callPopup(tag: textField.tag)
                            } else {
                                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: "No credit types found.", okBtnTitle: "OK", activityType: .show)
                            }
                        }
                        
                    }, andFailure: { (error) in
                        print ("error \((String(describing: error!.localizedDescription)))")
                    })
                } else {
                    self.callPopup(tag: textField.tag)
                }
            } else if arrPreferenceContent[textField.tag]["placeholderText"] as! String == "Location" {
                
                ApiCallingClass.BaseApiCallingGetMethod(withurlString: URLs.countryWithoutRegionURL, withSuccess: { (response) in
                    if response is [String: Any] {
                        print("From login")
                        print(response);
                        let mainResponse = response as! [String: Any]
                        let success = mainResponse["success"] as! Bool
                        
                        if success == true{
                            self.countryArr = mainResponse["data"] as! [[String: Any]]
                            self.callPopup(tag: textField.tag)
                        } else {
                            PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: "No countries found", okBtnTitle: "OK", activityType: .show)
                        }
                    }
                }, andFailure: { (error) in
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: (String(describing: error!.localizedDescription)), okBtnTitle: "OK", activityType: .show)
                    print ("error \((String(describing: error!.localizedDescription)))")
                })
            } else if arrPreferenceContent[textField.tag]["placeholderText"] as! String == "Financial Loan" {
                if loanArr.count == 0 {
                    ApiCallingClass.BaseApiCallingGetMethod(withurlString: URLs.loanTypeURL, withSuccess: { (response) in
                        
                        if response is [String: Any] {
                            print("From login")
                            print(response);
                            let mainResponse = response as! [String: Any]
                            let success = mainResponse["success"] as! Bool
                            
                            if success == true {
                                self.loanArr = mainResponse["data"] as! [[String: Any]]
                                self.callPopup(tag: textField.tag)
                            } else {
                                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: "No loan types found.", okBtnTitle: "OK", activityType: .show)
                            }
                        }
                        
                    }, andFailure: { (error) in
                        print ("error \((String(describing: error!.localizedDescription)))")
                    })
                } else {
                    self.callPopup(tag: textField.tag)
                }
            } else {
                self.callPopup(tag: textField.tag)
            }
            
            return false
            
        } else {
            return true
        }
    }
}
