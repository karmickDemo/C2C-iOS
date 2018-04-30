//
//  AdvancePropertyDetailsViewController.swift
//  C2C
//
//  Created by Karmick on 06/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Alamofire
import BSImagePicker
import Photos
import TTGSnackbar

class TextFieldCellDropDown: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var downBtn: UIButton!
    
    @IBAction func downBtnAction(_ sender: Any) {
        
    }
}

class TextViewCellForAdvanceDetails: UITableViewCell {
    
    @IBOutlet var containerView: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var placeholderLbl: UILabel!
    
}

class PriceAdvanceTableViewCell: UITableViewCell {
    @IBOutlet var txt_CurrencyType: UITextField!
    
    @IBOutlet var vw_priceBckgrd: UIView!
    @IBOutlet var vw_currencybckgrd: UIView!
    @IBOutlet var btn_dropdown: UIButton!
    @IBOutlet var txt_Price: UITextField!
}

class AdvancePropertyDetailsViewController: UIViewController {
    
    var SelectedAssets = [PHAsset]()
    
    let helper = imagePickerHelper()
    
    var sellerId: String!
    
    var contentArr = [[String : Any]]()
    @IBOutlet var registerBtn: UIButton!
    
    @IBOutlet var tableViewAdvanceDetail: UITableView!
    
    var regionArr = [[String: Any]]()
    var countryArr = [[String: Any]]()
    var creditTypeArr = [[String: Any]]()
    var loanTypeArr = [[String: Any]]()
    var currencyArr = [[String: Any]]()
    
    var imageDataForLegalDocuments = Data()
    var arrSelectedImages = [Any]()
    var phassetCount = Int()
    var is1stCredit = false
    
    var pageFrom: String!
    
    @IBOutlet var LegalDocumentsImageSelection: UIImageView!
    @IBOutlet var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("seller id : \(sellerId)")

        // Do any additional setup after loading the view.
        let dic1 = [
            "placeholderText": "Credit Name *",
            "type": "textbox",
            "text": "",
            "selectedIndex": "",
            ]
        let dic2 = [
            "placeholderText": "Credit Type *",
            "type": "dropdown",
            "text": "",
            "selectedIndex": "0",
            ]
        let dic3 = [
            "placeholderText": "Region *",
            "type": "dropdown",
            "text": "",
            "selectedIndex": "0",
            ]
        let dic4 = [
            "placeholderText": "Country *",
            "type": "dropdown",
            "text": "",
            "selectedIndex": "0",
            ]
        let dic5 = [
            "placeholderText": "Financial Loan Type",
            "type": "dropdown",
            "text": "",
            "selectedIndex": "0",
            ]
        let dic6 = [
            "placeholderText": "Currency",
            "type": "currencyDropdown",
            "text": "",
            "selectedIndex": "0",
            ]
        let dic7 = [
            "placeholderText": "Credit Description *",
            "type": "textarea",
            "text": "",
            ]
        let dic8 = [
            "placeholderText": "Price",
            "type": "textbox",
            "text": "",
            "selectedIndex": "0",
            ]
  
        contentArr = [dic1, dic2, dic3, dic4, dic5, dic6, dic7, dic8]
        
        if self.pageFrom == "propertyList" {
            self.backBtn.isHidden = false
        } else if self.pageFrom == "registrationSeller" {
            self.backBtn.isHidden = false
        }
        
        self.registerBtn.layer.cornerRadius = 22.5
        self.registerBtn.clipsToBounds = true
        
        self.tableViewAdvanceDetail.delegate = self
        self.tableViewAdvanceDetail.dataSource = self
        
        self.tableViewAdvanceDetail.reloadData()
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
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
    
    private func submitProperty () {
        
        var propertyTypeStr = String()
        var regionIdStr = String()
        var countryIdStr = String()
        var loanTypeStr = String()
        var currencyIdStr = String()
        
        
        if (contentArr[1]["text"] as! String).isEmpty {
            propertyTypeStr = ""
        } else {
            propertyTypeStr = creditTypeArr[Int(contentArr[1]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        if (contentArr[2]["text"] as! String).isEmpty {
            regionIdStr = ""
        } else {
            regionIdStr = regionArr[Int(contentArr[2]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        if (contentArr[3]["text"] as! String).isEmpty {
            countryIdStr = ""
        } else {
            countryIdStr = countryArr[Int(contentArr[3]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        if (contentArr[4]["text"] as! String).isEmpty {
            loanTypeStr = ""
        } else {
            loanTypeStr = loanTypeArr[Int(contentArr[4]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        if (contentArr[5]["text"] as! String).isEmpty {
            currencyIdStr = ""
        } else {
            currencyIdStr = currencyArr[Int(contentArr[5]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        let parameters : Parameters = [
            "property_name": contentArr[0]["text"] as! String,
            "property_type": propertyTypeStr,
            "prop_region": regionIdStr,
            "prop_country": countryIdStr,
            "financial_loan_type": loanTypeStr,
            "price": contentArr[contentArr.count - 1]["text"] as! String,
            "currency_id": currencyIdStr,
            "description": contentArr[contentArr.count - 2]["text"] as! String,
            "seller_id": self.sellerId,
            "device_type": "iOS",
            ]
        
        
        ApiCallingClass.requestWithMultipleImages(withurlString: URLs.insertNewProperty, forImageOne: self.imageDataForLegalDocuments, forImages: arrSelectedImages as! [Data], parameters: parameters, withSuccess: { (response) in
            if response is [String: Any] {
                
                print("response seller registration : \(response)");
                let mainResponse = response as! [String: Any]
                let success = mainResponse["success"] as! Bool
                
                if success == true {
                    
                    if self.pageFrom == "registrationSeller" {
                        PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: mainResponse["message"] as! String, okBtnTitle: "OK", activityType: .registrationSuccess)
                    } else if self.pageFrom == "propertyList" {
                        PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: mainResponse["message"] as! String, okBtnTitle: "OK", activityType: .propertyAdded)
                    }
                    
                    
                    
                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: mainResponse["message"] as! String, okBtnTitle: "OK", activityType: .show)
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
    
    
    @IBAction func btn_Register_Clicked(_ sender: Any) {
        
        if ((contentArr[0]["text"] as! String).isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Credit name can not be blank.", duration: TTGSnackbarDuration.middle)
        } else if ((contentArr[1]["text"] as! String).isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please select a Credit type.", duration: TTGSnackbarDuration.middle)
        } else if ((contentArr[2]["text"] as! String).isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please select a Region.", duration: TTGSnackbarDuration.middle)
        } else if ((contentArr[3]["text"] as! String).isBlank) {
            TTGSnackbarConfiguration.snackbarConfiguration(message: "Please select a Country.", duration: TTGSnackbarDuration.middle)
        } else {
            
            self.keyboardDown()
            
            self.submitProperty()
        }
    }
    
    func doneEditing(tag: Int , str: String, indexDropDown: Int) -> Void{
        
        var chunk = [String: Any]()
        chunk = contentArr[tag]
        
        if self.contentArr[tag]["type"] as! String == "dropdown" {
            
            chunk["selectedIndex"] = String(indexDropDown)
            chunk["text"] = str
            contentArr[tag] = chunk
            self.tableViewAdvanceDetail.reloadRows(at: [IndexPath(row: tag, section:0)], with: .none)
        } else if self.contentArr[tag]["type"] as! String == "currencyDropdown" {
            
            chunk["selectedIndex"] = String(indexDropDown)
            chunk["text"] = str
            contentArr[tag] = chunk
            self.tableViewAdvanceDetail.reloadRows(at: [IndexPath(row: tag, section:0)], with: .none)
        } else {
            chunk["text"] = str
            contentArr[tag] = chunk
        }
        
        print("CONTENT array==\(contentArr)")
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
        
        if headingName == "Region *" {
            arr = self.regionArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .region) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        } else if headingName == "Country *" {
            arr = self.countryArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .country) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        } else if headingName == "Credit Type *" {
            arr = self.creditTypeArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .creditType) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        } else if headingName == "Financial Loan Type" {
            arr = self.loanTypeArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .loanType) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        } else if headingName == "Currency" {
            arr = self.currencyArr
            PopupListingViewController.showPopUpListing(onParentViewController: self, heading: headingName, selectedIndexForList: selectedIndex, contents: arr, type: .currency) { (selectedValue, index) in
                print ("value is : \(selectedValue!), index is : \(index!)")
                
                self.doneEditing(tag: tag, str: selectedValue!, indexDropDown: index!)
            }
        }
    }
    
    @IBAction func btn_legalDocuments_click(_ sender: Any) {
        
        self.keyboardDown()
        
        ImagePickerViewController.showImagePicker(onParentViewController: self) { (selectedString, selectedindex) in
            print("\(selectedString as String?)")
            print("\(selectedindex as NSInteger?)")
            
            if selectedString! == "Camera"
            {
                self.helper.opencamera(withParentViewController: self, source: .camera)
                {selectedimage,_  in ()
                    print("image==\(selectedimage as UIImage?)")
                    self.imageDataForLegalDocuments = UIImagePNGRepresentation(selectedimage!)!
                    print("imgdata1==\(self.imageDataForLegalDocuments)")
                    self.LegalDocumentsImageSelection.image = UIImage (named: "ok")
                }
                
            }
            else if selectedString! == "Gallery" {
                self.helper.showlibarary(onParentViewController: self, source: .photoLibrary, didSelectImage: { (myselectedImg ,_ )  in
                    print("image==\(myselectedImg as UIImage?)")
                    self.imageDataForLegalDocuments = UIImagePNGRepresentation(myselectedImg!)!
                    print("imagedata2==\( self.imageDataForLegalDocuments)")
                    self.LegalDocumentsImageSelection.image = UIImage (named: "ok")
                })
                
            }
            else{
                
            }
        }
    }
    
    @IBAction func btn_CreditImages_Click(_ sender: Any) {
        
        self.keyboardDown()
        
        let vc = BSImagePickerViewController()
        
        vc.maxNumberOfSelections = 6
        vc.selectionFillColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha:1)
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            print("Finish: \(assets)")
            print("photos==\(vc.takePhotoIcon as UIImage?)")
            print(assets.count)
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
                print(self.SelectedAssets)
            }
            
            self.getAllImages()
            
        }, completion: nil)
        
    }
    
    @objc func getAllImages() -> Void {
        
        print("SelectedAssets.count==\(SelectedAssets.count)")
        if is1stCredit {
            for i in (0..<phassetCount).reversed(){
                self.SelectedAssets.remove(at: i)
            }
            self.is1stCredit = false
        }
        else{
//            [27268 bytes, 65219 bytes, 66365 bytes, 69143 bytes]
        }
        
        print("get all images method called here")
        var arrImages = [Any]()
        arrSelectedImages = [Any]()
        if SelectedAssets.count != 0{
            for i in 0..<SelectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                is1stCredit = true
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                phassetCount = SelectedAssets.count
                arrImages.append(thumbnail)
                print("arrImages==\(arrImages)")
                var imagedata = Data()
                
                //                imagedata = UIImageJPEGRepresentation((thumbnail), 1)!
                //                arrSelectedImages.insert(imagedata, at: i)
                //                print("imagedata==\(imagedata)")
                
                print(arrSelectedImages.count)
                
                for dataConvet in arrImages {
                    print("Hello, \(dataConvet)!")
                    imagedata = UIImageJPEGRepresentation(dataConvet as! UIImage, 1)!
                }
                arrSelectedImages.insert(imagedata, at: i)
                print("arrSelectedImages==\(arrSelectedImages)")
                print("arrSelectedImages.count==\(arrSelectedImages.count)")
                
                
                
            }
        }
        
    }
}

extension AdvancePropertyDetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let cell = self.tableViewAdvanceDetail.cellForRow(at: IndexPath(row: textView.tag, section: 0)) as! TextViewCellForAdvanceDetails
        
        if !(textView.hasText) {
            cell.placeholderLbl.isHidden = false
        } else {
            cell.placeholderLbl.isHidden = true
        }
        
        self.doneEditing(tag: textView.tag, str: textView.text, indexDropDown: 0)
    }
    
    
}

extension AdvancePropertyDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArr.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if contentArr[indexPath.row]["type"] as? String == "textbox" {
            
            let cellNormal = tableView.dequeueReusableCell(withIdentifier: "textFieldCellNormalForSeller", for: indexPath) as! TextFieldCellNormalForSeller
            
            cellNormal.containerView.layer.borderWidth = 1
            cellNormal.containerView.layer.borderColor = placeHolderColor.cgColor
            cellNormal.containerView.layer.cornerRadius = 20
            cellNormal.containerView.clipsToBounds = true
            
            cellNormal.textField.tag = indexPath.row
            cellNormal.textField!.delegate = self
            
            cellNormal.textField!.text = contentArr[indexPath.row]["text"] as? String
            cellNormal.textField!.placeholder = contentArr[indexPath.row]["placeholderText"] as? String
            
            cellNormal.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cellNormal
            
        } else if contentArr[indexPath.row]["type"] as? String == "textarea" {
            
            let cellTextView = tableView.dequeueReusableCell(withIdentifier: "textViewCellForAdvanceDetails", for: indexPath) as! TextViewCellForAdvanceDetails
            
            cellTextView.containerView.layer.borderWidth = 1
            cellTextView.containerView.layer.borderColor = placeHolderColor.cgColor
            cellTextView.containerView.layer.cornerRadius = 20
            cellTextView.containerView.clipsToBounds = true
            
            cellTextView.textView.tag = indexPath.row
            cellTextView.textView!.delegate = self
            
            cellTextView.textView.textContainerInset = UIEdgeInsets.zero
            cellTextView.textView.textContainer.lineFragmentPadding = 0;
            
            if cellTextView.textView.hasText || (contentArr[indexPath.row]["text"] as? String)!.count > 0 {
                cellTextView.placeholderLbl.isHidden = true
            }
            else {
                cellTextView.placeholderLbl.isHidden = false
            }
            
            cellTextView.textView!.text = contentArr[indexPath.row]["text"] as? String
            cellTextView.placeholderLbl!.text = contentArr[indexPath.row]["placeholderText"] as? String
            
            
            cellTextView.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cellTextView
            
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
            
        } else if contentArr[indexPath.row]["type"] as? String == "currencyDropdown" {
            
            let PriceAdvancecell = tableView.dequeueReusableCell(withIdentifier: "PriceAdvanceTableViewCell", for: indexPath) as! PriceAdvanceTableViewCell
            
            PriceAdvancecell.vw_priceBckgrd.layer.borderWidth = 1
            PriceAdvancecell.vw_priceBckgrd.layer.borderColor = placeHolderColor.cgColor
            PriceAdvancecell.vw_priceBckgrd.layer.cornerRadius = 20
            PriceAdvancecell.vw_priceBckgrd.clipsToBounds = true
            
            PriceAdvancecell.vw_currencybckgrd.layer.borderWidth = 1
            PriceAdvancecell.vw_currencybckgrd.layer.borderColor = placeHolderColor.cgColor
            PriceAdvancecell.vw_currencybckgrd.layer.cornerRadius = 20
            PriceAdvancecell.vw_currencybckgrd.clipsToBounds = true

            PriceAdvancecell.txt_CurrencyType.tag = indexPath.row
            PriceAdvancecell.txt_Price.tag = self.contentArr.count - 1


            PriceAdvancecell.txt_CurrencyType!.text = contentArr[indexPath.row]["text"] as? String
            PriceAdvancecell.txt_CurrencyType!.placeholder = contentArr[indexPath.row]["placeholderText"] as? String
            
            PriceAdvancecell.txt_Price!.text = contentArr[self.contentArr.count - 1]["text"] as? String
            PriceAdvancecell.txt_Price!.placeholder = contentArr[self.contentArr.count - 1]["placeholderText"] as? String
            
            PriceAdvancecell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return PriceAdvancecell
        }
        //
        else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if contentArr[indexPath.row]["type"] as? String == "textbox" {
            return 50
        } else if contentArr[indexPath.row]["type"] as? String == "textarea" {
            return 80
        } else if contentArr[indexPath.row]["type"] as? String == "dropdown" {
            return 50
        }
        else if contentArr[indexPath.row]["type"] as? String == "currencyDropdown" {
            return 50
        }else {
            return 0
        }
    }
}


extension AdvancePropertyDetailsViewController: UITextFieldDelegate {
    
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
            
            if contentArr[textField.tag]["placeholderText"] as! String == "Credit Type *" {
                
                if creditTypeArr.count == 0 {
                    ApiCallingClass.BaseApiCallingGetMethod(withurlString: URLs.propertyTypeURL, withSuccess: { (response) in
                        
                        if response is [String: Any] {
                            print(response);
                            let mainResponse = response as! [String: Any]
                            let success = mainResponse["success"] as! Bool
                            
                            if success == true {
                                self.creditTypeArr = mainResponse["data"] as! [[String: Any]]
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
            } else if contentArr[textField.tag]["placeholderText"] as! String == "Region *" {
                
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
                                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: "No region found.", okBtnTitle: "OK", activityType: .show)
                            }
                        }
                        
                    }, andFailure: { (error) in
                        print ("error \((String(describing: error!.localizedDescription)))")
                    })
                } else {
                    self.callPopup(tag: textField.tag)
                }
            } else if contentArr[textField.tag]["placeholderText"] as! String == "Country *" {
                
                if contentArr[textField.tag - 1]["text"] as! String == "" {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: "Please select a Region before selecting country.", okBtnTitle: "OK", activityType: .show)
                } else {
                    
                    let index = contentArr[textField.tag - 1]["selectedIndex"] as! String
                    
                    let parameters : Parameters = [
                        "region_id": regionArr[Int(index)!]["id"] as! String,
                        ]
                    
                    ApiCallingClass.BaseApiCalling(withurlString: URLs.countryURL, withParameters: parameters, withSuccess: { (response) in
                        
                        if response is [String: Any] {
                            print("From login")
                            print(response);
                            let mainResponse = response as! [String: Any]
                            let success = mainResponse["success"] as! Bool
                            
                            if success == true{
                                self.countryArr = mainResponse["data"] as! [[String: Any]]
                                self.callPopup(tag: textField.tag)
                            } else {
                                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: "No countries found for this region", okBtnTitle: "OK", activityType: .show)
                            }
                        }
                        
                    }) { (error) in
                        print ("error \((String(describing: error!.localizedDescription)))")
                        
                    }
                }
            } else if contentArr[textField.tag]["placeholderText"] as! String == "Financial Loan Type" {
                if loanTypeArr.count == 0 {
                    ApiCallingClass.BaseApiCallingGetMethod(withurlString: URLs.loanTypeURL, withSuccess: { (response) in
                        
                        if response is [String: Any] {
                            print("From login")
                            print(response);
                            let mainResponse = response as! [String: Any]
                            let success = mainResponse["success"] as! Bool
                            
                            if success == true {
                                self.loanTypeArr = mainResponse["data"] as! [[String: Any]]
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
            
        } else if contentArr[textField.tag]["type"] as! String == "currencyDropdown" {
             self.keyboardDown()
            if currencyArr.count == 0 {
                ApiCallingClass.BaseApiCallingGetMethod(withurlString: URLs.currencyURL, withSuccess: { (response) in
                    
                    if response is [String: Any] {
                        print("From login")
                        print(response);
                        let mainResponse = response as! [String: Any]
                        let success = mainResponse["success"] as! Bool
                        
                        if success == true {
                            self.currencyArr = mainResponse["data"] as! [[String: Any]]
                            self.callPopup(tag: textField.tag)
                        } else {
                            PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Opps", descriptionText: "No currency types available.", okBtnTitle: "OK", activityType: .show)
                        }
                    }
                    
                }, andFailure: { (error) in
                    print ("error \((String(describing: error!.localizedDescription)))")
                })
            } else {
                self.callPopup(tag: textField.tag)
            }
            return false
        } else {
            return true
        }
    }
}




