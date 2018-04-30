//
//  RegistrationAsSellerViewController.swift
//  C2C
//
//  Created by Karmick on 05/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Alamofire
import TTGSnackbar

extension RegistrationBuyerViewController: UITextFieldDelegate {
    
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
        
        if contentArr[textField.tag]["type"] as! String == "dropdown" {
            
            self.keyboardDown()
            
            if contentArr[textField.tag]["placeholderText"] as! String == "Region" {
                
                if regionArr.count == 0 {
                    
                    ApiCallingClass.BaseApiCallingGetMethod(withurlString: URLs.regionURL, withSuccess: { (response) in
                        
                        if response is [String: Any] {
                            print("From login")
                            print(response);
                            let mainResponse = response as! [String: Any]
                            let success = mainResponse["success"] as! Bool
                            
                            if success == true {
                                self.regionArr = mainResponse["data"] as! [[String: Any]]
                                self.callPopup(tag: textField.tag)
                            } else {
                                
                            }
                        }
                        
                    }, andFailure: { (error) in
                        print ("error \((String(describing: error!.localizedDescription)))")
                    })
                } else {
                    self.callPopup(tag: textField.tag)
                }
            } else if contentArr[textField.tag]["placeholderText"] as! String == "Country" {
                
//                if contentArr[textField.tag - 1]["text"] as! String == "" {
//                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: "Please select a Region before selecting country.", okBtnTitle: "OK", activityType: .show)
//                } else {
                
//                    let index = contentArr[textField.tag - 1]["selectedIndex"] as! String
//
//                    let parameters : Parameters = [
//                        "region_id": regionArr[Int(index)!]["id"] as! String,
//                        ]
                
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
                
//                    ApiCallingClass.BaseApiCalling(withurlString: URLs.countryURL, withParameters: parameters, withSuccess: { (response) in
//                        
//                        if response is [String: Any] {
//                            print("From login")
//                            print(response);
//                            let mainResponse = response as! [String: Any]
//                            let success = mainResponse["success"] as! Bool
//                            
//                            if success == true{
//                                self.countryArr = mainResponse["data"] as! [[String: Any]]
//                                self.callPopup(tag: textField.tag)
//                            } else {
//                                
//                            }
//                        }
//                        
//                    }) { (error) in
//                        print ("error \((String(describing: error!.localizedDescription)))")
//                        
//                    }
//                }
            } else {
                self.callPopup(tag: textField.tag)
            }
            
            return false
            
        } else {
            return true
        }
    }
}

extension RegistrationBuyerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if contentArr[indexPath.row]["type"] as? String == "textbox" {
            
            if indexPath.row == 3 {
                
                let cellPassword = tableView.dequeueReusableCell(withIdentifier: "textFieldCellPasswordForSeller", for: indexPath) as! TextFieldCellPasswordForSeller
                
                cellPassword.containerView.layer.borderWidth = 1
                cellPassword.containerView.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
                cellPassword.containerView.layer.cornerRadius = 20
                cellPassword.containerView.clipsToBounds = true
                
                cellPassword.textField.tag = indexPath.row
                
                
                cellPassword.textField!.text = contentArr[indexPath.row]["text"] as? String
                cellPassword.textField!.placeholder = contentArr[indexPath.row]["placeholderText"] as? String
                
                cellPassword.selectionStyle = UITableViewCellSelectionStyle.none
                
                return cellPassword
                
            } else {
                
                let cellNormal = tableView.dequeueReusableCell(withIdentifier: "textFieldCellNormalForSeller", for: indexPath) as! TextFieldCellNormalForSeller
                
              
                
                cellNormal.containerView.layer.borderWidth = 1
                cellNormal.containerView.layer.borderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1).cgColor
                cellNormal.containerView.layer.cornerRadius = 20
                cellNormal.containerView.clipsToBounds = true
                
                cellNormal.textField.tag = indexPath.row
                cellNormal.textField.delegate = self
                
                cellNormal.textField!.text = contentArr[indexPath.row]["text"] as? String
                cellNormal.textField!.placeholder = contentArr[indexPath.row]["placeholderText"] as? String
                
                cellNormal.selectionStyle = UITableViewCellSelectionStyle.none
                if indexPath.row == 2{
                    cellNormal.textField.keyboardType = .emailAddress
                    cellNormal.textField.autocorrectionType = .no
                    cellNormal.textField.autocapitalizationType = .none
                    cellNormal.textField.spellCheckingType = .no
                }else{
                    cellNormal.textField.keyboardType = .asciiCapable
                }
                
                return cellNormal
            }
            
        } else if contentArr[indexPath.row]["type"] as? String == "dropdown" {
            
            let cellDropDown = tableView.dequeueReusableCell(withIdentifier: "textFieldCellDropDown", for: indexPath) as! TextFieldCellDropDown
            
            cellDropDown.containerView.layer.borderWidth = 1
            cellDropDown.containerView.layer.borderColor = placeHolderColor.cgColor
            cellDropDown.containerView.layer.cornerRadius = 20
            cellDropDown.containerView.clipsToBounds = true
            
            cellDropDown.textField.tag = indexPath.row
            cellDropDown.textField!.delegate = self
            
            cellDropDown.textField!.text = contentArr[indexPath.row]["text"] as? String
            cellDropDown.textField!.placeholder = contentArr[indexPath.row]["placeholderText"] as? String
            
            cellDropDown.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cellDropDown
            
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

private typealias urlFireMethods = RegistrationBuyerViewController
extension urlFireMethods {
    
    func submitRegisterBuyerAction() -> Void {
        
//        var regionIdStr = String()
        var countryIdStr = String()
        
//        if (contentArr[4]["text"] as! String).isEmpty {
//            regionIdStr = ""
//        } else {
//            regionIdStr = regionArr[Int(contentArr[4]["selectedIndex"] as! String)!]["id"] as! String
//        }
        
        if (contentArr[4]["text"] as! String).isEmpty {
            countryIdStr = ""
        } else {
            countryIdStr = countryArr[Int(contentArr[4]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        let parameters : Parameters = [
            "fname": contentArr[0]["text"] as! String,
            "lname": contentArr[1]["text"] as! String,
            "email": contentArr[2]["text"] as! String,
            "password" : contentArr[3]["text"] as! String,
//            "region" : regionIdStr,
            "country" : countryIdStr,
            "city" : contentArr[5]["text"] as! String,
            "device_id": "efjvds132304rfjsocnrekltn3oeqd09435795",
            "device_type": "iOS",
            ]
        
        ApiCallingClass.requestWithImage(withurlString: URLs.registrationBuyerURL, forImageOne: self.imageDataForIdProof, forImageTwo: self.imageDataForTradeLicense, parameters: parameters, withSuccess: { (response) in
            if response is [String: Any] {
                
                print("response buyer registration : \(response)");
                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool
                
                if success == true{
                    
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Successful", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .registrationSuccess)
                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
                }
            }
            
        }) { (error) in
            
            print ("error \((String(describing: error!.localizedDescription)))")
            
            if (error)?.errorCode == -200 {
                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Not connected", descriptionText: "Device is not connected to internet.", okBtnTitle: "OK", activityType: .show)
            } else {
                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: error!.localizedDescription, okBtnTitle: "OK", activityType: .show)
            }
        }
    }
}


class TextFieldCellNormalForSeller: UITableViewCell{
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var textField: UITextField!
}

class TextFieldCellPasswordForSeller: UITableViewCell{
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var showPasswordBtn: UIButton!
    
    @IBAction func showPasswordAction(_ sender: Any) {
        
        if self.showPasswordBtn.isSelected == true
        {
            self.showPasswordBtn.setImage(UIImage(named: "passwordVisible"), for: UIControlState.normal)
            self.textField.isSecureTextEntry = true
            self.showPasswordBtn.isSelected = false
        }
        else
        {
            self.showPasswordBtn.setImage(UIImage(named: "passwordNotVisible"), for: UIControlState.selected)
            self.textField.isSecureTextEntry = false
            self.showPasswordBtn.isSelected = true
        }
    }
}

class RegistrationBuyerViewController: UIViewController {
    
    @IBOutlet var btn_Buyer: UIButton!
    @IBOutlet var btn_Seller: UIButton!
    @IBOutlet var registrationTableView: UITableView!
    @IBOutlet var saveBtn: UIButton!
    
    var contentArr = [[String : Any]]()
    var pageType = String()
    let helper = imagePickerHelper()
    var imageDataForIdProof = Data()
    var imageDataForTradeLicense = Data()

    var regionArr = [[String: Any]]()
    var countryArr = [[String: Any]]()
    
    @IBOutlet var idProofImageSelection: UIImageView!
    @IBOutlet var tradeLicenseImageSelection: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        saveBtn.layer.cornerRadius = 22.5
        saveBtn.clipsToBounds = true
        
        let dic1 = [
            "placeholderText": "First Name *",
            "type": "textbox",
            "text": "",
            "selectedIndex": "",
            ]
        let dic2 = [
            "placeholderText": "Last Name *",
            "type": "textbox",
            "text": "",
            "selectedIndex": "",
            ]
        let dic3 = [
            "placeholderText": "Email *",
            "type": "textbox",
            "text": "",
            "selectedIndex": "",
            ]
        let dic4 = [
            "placeholderText": "Password *",
            "type": "textbox",
            "text": "",
            "selectedIndex": "",
            ]
        let dic5 = [
            "placeholderText": "Region",
            "type": "dropdown",
            "text": "",
            "selectedIndex": "0",
            ]
        let dic6 = [
            "placeholderText": "Country",
            "type": "dropdown",
            "text": "",
            "selectedIndex": "0",
            ]
        let dic7 = [
            "placeholderText": "City",
            "type": "textbox",
            "text": "",
            "selectedIndex": "",
            ]
        
        contentArr = [dic1, dic2, dic3, dic4, dic6, dic7]
        
        self.registrationTableView.delegate = self;
        self.registrationTableView.dataSource = self;
        
        self.registrationTableView.reloadData()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: false)
                break
            }
        }
    }
    
    private func doneEditing(tag: Int, str: String, indexDropDown: Int) -> Void{
        
        var chunk = [String: Any]()
        chunk = contentArr[tag]
        
        if self.contentArr[tag]["type"] as! String == "dropdown" {
            chunk["selectedIndex"] = String(indexDropDown)
            chunk["text"] = str
            contentArr[tag] = chunk
            self.registrationTableView.reloadRows(at: [IndexPath(row: tag, section:0)], with: .none)
        } else {
            chunk["text"] = str
            contentArr[tag] = chunk
        }
        
        print("CONTENT array==\(contentArr)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Buttion Actions
    @IBAction func btn_Buyer_Registration_Click(_ sender: Any) {
        
    }
    
    @IBAction func btn_Seller_Registration_Click(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mRegistrationSellerViewController = storyBoard.instantiateViewController(withIdentifier: "RegistrationSellerViewController") as! RegistrationSellerViewController
        self.navigationController?.pushViewController(mRegistrationSellerViewController, animated: false)
        
    }
    
    
    @IBAction func btn_CreateAnAccount_Clicked(_ sender: Any)
    {
        if ((contentArr[0]["text"] as! String).isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "First name can not be blank", duration: TTGSnackbarDuration.middle)
        } else if ((contentArr[1]["text"] as! String).isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Last name can not be blank", duration: TTGSnackbarDuration.middle)
        } else if ((contentArr[2]["text"] as! String).isEmail()) == false {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please enter a valid email", duration: TTGSnackbarDuration.middle)
        } else if ((contentArr[3]["text"] as! String).isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Password field can not be blank", duration: TTGSnackbarDuration.middle)
        } else {
            
            self.keyboardDown()
            self.submitRegisterBuyerAction()
        }
    }
   
    @IBAction func btn_pickImgForIdProof_Click(_ sender: Any) {
        
        self.keyboardDown()
        
        ImagePickerViewController.showImagePicker(onParentViewController: self) { (selectedString, selectedindex) in
            print("\(selectedString as String?)")
            print("\(selectedindex as NSInteger?)")
            
            
            
            if selectedString! == "Camera"
            {
                self.helper.opencamera(withParentViewController: self, source: .camera)
                {selectedimage,_  in ()
                    print("image==\(selectedimage as UIImage?)")
                    self.imageDataForIdProof = UIImageJPEGRepresentation(selectedimage!, 0.8)!
                    print("imgdata1==\(self.imageDataForIdProof)")
                    self.idProofImageSelection.image = UIImage (named: "ok")
                    
                }
                
            }
            else if selectedString! == "Gallery" {
                self.helper.showlibarary(onParentViewController: self, source: .photoLibrary, didSelectImage: { (myselectedImg ,_ )  in
                    print("image==\(myselectedImg as UIImage?)")
                    self.imageDataForIdProof = UIImageJPEGRepresentation(myselectedImg!, 0.8)!
                    print("imagedata2==\( self.imageDataForIdProof)")
                    self.idProofImageSelection.image = UIImage (named: "ok")
                })
                
            }
            else{
                
            }
        }
    }
    
    @IBAction func btn_pickImgForTradeLicense_Click(_ sender: Any) {
        
        self.keyboardDown()
        
        ImagePickerViewController.showImagePicker(onParentViewController: self) { (selectedString, selectedindex) in
            print("\(selectedString as String?)")
            print("\(selectedindex as NSInteger?)")
            
            if selectedString! == "Camera"
            {
                self.helper.opencamera(withParentViewController: self, source: .camera)
                {selectedimage,_  in ()
                    print("image==\(selectedimage as UIImage?)")
                    self.imageDataForTradeLicense = UIImagePNGRepresentation(selectedimage!)!
                    print("imgdata1==\(self.imageDataForTradeLicense)")
                    self.tradeLicenseImageSelection.image = UIImage (named: "ok")
                }
                
            }
            else if selectedString! == "Gallery" {
                self.helper.showlibarary(onParentViewController: self, source: .photoLibrary, didSelectImage: { (myselectedImg ,_ )  in
                    print("image==\(myselectedImg as UIImage?)")
                    self.imageDataForTradeLicense = UIImagePNGRepresentation(myselectedImg!)!
                    print("imagedata2==\( self.imageDataForTradeLicense)")
                    self.tradeLicenseImageSelection.image = UIImage (named: "ok")
                })
                
            }
            else{
                
            }
        }
    }
    
    func keyboardDown() -> Void {

        self.view.layoutIfNeeded()
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
    }

    func callPopup(tag: Int) -> Void {
        
        let selectedIndex = contentArr[tag]["selectedIndex"] as! String
        let headingName = contentArr[tag]["placeholderText"] as! String
        
        var arr = [[String: Any]]()
        
        if headingName == "Region" {
            arr = self.regionArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .region) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        }
        else if headingName == "Country" {
            arr = self.countryArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .country) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        }
        
        
    }
    
    
    
      // MARK: - Imagepicker delegate
    
//    func openCamera() -> Void{
//        helper.opencamera(withParentViewController: self, source: .camera)
//        {selectedimage,selectedvalue  in ()
//            if selectedvalue == true{
//                print(selectedimage)
//
//                self.dataForIdProof = UIImageJPEGRepresentation(selectedimage!, 0.8)!
//                let strBase64 = self.dataForIdProof.base64EncodedString(options: .lineLength64Characters)
//
//               // self.uploadImage(withImage: strBase64)
//            }
//            else{
//
//            }
//
//
//        }
//    }
    
}
