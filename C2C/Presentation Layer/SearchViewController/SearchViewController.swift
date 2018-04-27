//
//  SearchViewController.swift
//  C2C
//
//  Created by Karmick on 09/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import WARangeSlider
import Alamofire

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrSearchContent[indexPath.row]["type"] as! String == "textbox" {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "TextFieldCellNormalForSeller", for: indexPath) as! TextFieldCellNormalForSeller
            
            cell1.containerView.layer.borderWidth = 1
            cell1.containerView.layer.borderColor = placeHolderColor.cgColor
            cell1.containerView.layer.cornerRadius = 20
            cell1.containerView.clipsToBounds = true
            
            cell1.textField.tag = indexPath.row
            
            cell1.textField!.placeholder = arrSearchContent[indexPath.row]["placeholderText"] as? String
            cell1.textField!.text = arrSearchContent[indexPath.row]["text"] as? String
            cell1.selectionStyle = .none
            
            return cell1
            
        } else if arrSearchContent[indexPath.row]["type"] as! String == "dropdown" {
            
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "TextFieldCellDropDown", for: indexPath) as! TextFieldCellDropDown
            
            cell3.containerView.layer.borderWidth = 1
            cell3.containerView.layer.borderColor = placeHolderColor.cgColor
            cell3.containerView.layer.cornerRadius = 20
            cell3.containerView.clipsToBounds = true
            
            cell3.textField.tag = indexPath.row
            
            cell3.textField!.placeholder = arrSearchContent[indexPath.row]["placeholderText"] as? String
            cell3.textField!.text = arrSearchContent[indexPath.row]["text"] as? String
            
            cell3.selectionStyle = .none
            
            return cell3
            
        } else {
            let cell = UITableViewCell()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
        
    }
 
}

class SearchViewController: UIViewController {
    
    @IBOutlet var lbl_range_Show: UILabel!
    @IBOutlet var btn_search: UIButton!
    @IBOutlet var vw_slider: UIView!
    let rangeSlider1 = RangeSlider(frame: CGRect.zero)

    @IBOutlet var tblvw_Search: UITableView!
    
    var arrSearchContent = [[String:Any]]()
    var countryArr = [[String:Any]]()
    var propertyArr = [[String:Any]]()
    var loanArr = [[String:Any]]()
    var user_id: Int?

    @IBOutlet var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblvw_Search.alwaysBounceVertical = false
        
        rangeSlider1.trackHighlightTintColor = UIColor(red:250/255, green:192/255, blue:77/255, alpha:1)
        rangeSlider1.curvaceousness = 25.0
        rangeSlider1.thumbTintColor =  UIColor(red:250/255, green:192/255, blue:77/255, alpha:1)
        rangeSlider1.thumbBorderColor = UIColor(red:235/255, green:175/255, blue:63/255, alpha:1)
        rangeSlider1.trackTintColor = UIColor(red:194/255, green:194/255, blue:194/255, alpha:1)
        
        UIApplication.shared.statusBarView?.backgroundColor = headerColor
        
        
        self.user_id =  UserDefaults.standard.integer(forKey: "user_id")
        
//        if self.user_id! != 0 {
//            self.menuBtn.setImage(UIImage(named: "menu"), for: .normal)
//            self.menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
//        } else {
//            self.menuBtn.setImage(UIImage(named: "back"), for: .normal)
//            self.menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        }
        
        self.vw_slider.addSubview(rangeSlider1)
        rangeSlider1.addTarget(self, action: #selector(SearchViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        self.btn_search.layer.cornerRadius=20
        self.btn_search.clipsToBounds = true
        
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
        let dic4 = [
            "placeholderText": "Search Criteria",
            "text": "",
            "selectedIndex": "",
            "image": "search",
            "type": "textbox",
            ]
        
        arrSearchContent = [dic1, dic2, dic3, dic4]
        
//        let parameter: Parameters = [
//        "user_id": "2",
//        ]
//        
//        ApiCallingClass.BaseApiCalling(withurlString: "http://192.168.1.22/croom/api/" + "get_prefferences", withParameters: parameter, withSuccess: { (response) in
//    
//        
//        }, andFailure: { (error) in
//        print ("error \((String(describing: error!.localizedDescription)))")
//        })
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
    //  let margin: CGFloat = 20.0
    // let width = self.vw_slider.bounds.width - 2.0 * margin
        let width = self.vw_slider.bounds.width

        rangeSlider1.frame = CGRect(x: self.vw_slider.bounds.origin.x, y: self.vw_slider.bounds.origin.y,
                                    width: width, height: 15.0)
       
    }
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
    }
    
    
    
// MARK: - UIButton actions
    
    @IBAction func btn_Search_Click(_ sender: Any) {
        
        
//        self.serachProperties()
        
        var propertyTypeStr = String()
        var countryIdStr = String()
        var loanTypeStr = String()
        
        if (arrSearchContent[0]["text"] as! String).isEmpty {
            countryIdStr = ""
        } else {
            countryIdStr = countryArr[Int(arrSearchContent[0]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        if (arrSearchContent[1]["text"] as! String).isEmpty {
            propertyTypeStr = ""
        } else {
            propertyTypeStr = propertyArr[Int(arrSearchContent[1]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        if (arrSearchContent[2]["text"] as! String).isEmpty {
            loanTypeStr = ""
        } else {
            loanTypeStr = loanArr[Int(arrSearchContent[2]["selectedIndex"] as! String)!]["id"] as! String
        }
        
        
        let parameters : Parameters = [
            "country": countryIdStr,
            "property": propertyTypeStr,
            "financial_loan": loanTypeStr,
            "keyword": arrSearchContent[3]["text"] as! String,
            ]
        
        let mSearchDetailsViewController = instantiateViewController(storyboardID: "SearchDetailsViewController") as! SearchDetailsViewController
        mSearchDetailsViewController.contentArr = arrSearchContent
        mSearchDetailsViewController.parameterSearch = parameters
        self.navigationController?.pushViewController(mSearchDetailsViewController, animated: true)
    }
    
//    private func serachProperties () {
//
//        var propertyTypeStr = String()
//        var countryIdStr = String()
//        var loanTypeStr = String()
//
//        if (arrSearchContent[0]["text"] as! String).isEmpty {
//            countryIdStr = ""
//        } else {
//            countryIdStr = countryArr[Int(arrSearchContent[0]["selectedIndex"] as! String)!]["id"] as! String
//        }
//
//        if (arrSearchContent[1]["text"] as! String).isEmpty {
//            propertyTypeStr = ""
//        } else {
//            propertyTypeStr = propertyArr[Int(arrSearchContent[1]["selectedIndex"] as! String)!]["id"] as! String
//        }
//
//        if (arrSearchContent[2]["text"] as! String).isEmpty {
//            loanTypeStr = ""
//        } else {
//            loanTypeStr = loanArr[Int(arrSearchContent[2]["selectedIndex"] as! String)!]["id"] as! String
//        }
//
//
//        let parameters : Parameters = [
//            "country": countryIdStr,
//            "property": propertyTypeStr,
//            "financial_loan": loanTypeStr,
//            "keyword": arrSearchContent[3]["text"] as! String,
//            ]
//
//        ApiCallingClass.BaseApiCalling(withurlString: URLs.searchPropertyURL, withParameters: parameters, withSuccess: { (response) in
//
//            if response is [String: Any] {
//
//                print(response);
//                let Main_response = response as! [String: Any]
//                let success = Main_response["success"] as! Bool
//
//                if success == true{
//
//                } else {
//
//                }
//            }
//
//        }) { (error) in
//            print ("error \((String(describing: error!.localizedDescription)))")
//
//        }
//    }
    

    @IBAction func btn_Back_Click(_ sender: Any) {
        
//        self.view.endEditing(true)
//
//        if self.user_id! != 0 {
//            LeftMenuViewController.showLeftMenu(onParentViewController: self) { (_, _) in
//            }
//        } else {
//            self.navigationController?.popViewController(animated: true)
//        }
    self.navigationController?.popViewController(animated: false)
    }
    
    private func doneEditing(tag: Int, str: String, indexDropDown: Int) -> Void{
        
        var chunk = [String: Any]()
        chunk = arrSearchContent[tag]
        
        if self.arrSearchContent[tag]["type"] as! String == "dropdown" {
            chunk["selectedIndex"] = String(indexDropDown)
            chunk["text"] = str
            arrSearchContent[tag] = chunk
            self.tblvw_Search.reloadRows(at: [IndexPath(row: tag, section:0)], with: .none)
        } else {
            chunk["text"] = str
            arrSearchContent[tag] = chunk
        }
        
        print("CONTENT array==\(arrSearchContent)")
    }
    
    func callPopup(tag: Int) -> Void {
        
        let selectedIndex = arrSearchContent[tag]["selectedIndex"] as! String
        let headingName = arrSearchContent[tag]["placeholderText"] as! String
        
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
}

extension SearchViewController: UITextFieldDelegate {
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
        
        if arrSearchContent[textField.tag]["type"] as! String == "dropdown" {
            
            self.keyboardDown()
            
            if arrSearchContent[textField.tag]["placeholderText"] as! String == "Property/Business" {
                
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
            } else if arrSearchContent[textField.tag]["placeholderText"] as! String == "Location" {
                
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
            } else if arrSearchContent[textField.tag]["placeholderText"] as! String == "Financial Loan" {
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
