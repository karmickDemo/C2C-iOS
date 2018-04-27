//
//  SellerPropertiesViewController.swift
//  C2C
//
//  Created by Karmick on 25/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Alamofire

class SellerPropertiesCell: UITableViewCell {
    
    @IBOutlet var lbl_CreditAmount: UILabel!
    @IBOutlet var lbl_CreditName: UILabel!
    @IBOutlet var lbl_PropertyType: UILabel!
    @IBOutlet var lbl_AdminStatus: UILabel!
}

extension SellerPropertiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sellerPropertiesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerPropertiesCell", for: indexPath) as! SellerPropertiesCell
        
        if let propName = self.sellerPropertiesArr[indexPath.row]["title"] as? String {
            cell.lbl_CreditName.text = propName
        }
        
        var creditType = String()
        var loanType = String()
        var currency = String()
        var price = String()
        
        if let credit = self.sellerPropertiesArr[indexPath.row]["property_type_name"] as? String {
            creditType = credit
        }
        
        if let loan = self.sellerPropertiesArr[indexPath.row]["financial_loan_type_name"] as? String {
            loanType = loan
        }
        
        cell.lbl_PropertyType.text = "Credit type : " + creditType + " | " + "Loan type : " + loanType
        
        if self.sellerPropertiesArr[indexPath.row]["admin_status"] as? String == "6" {
            cell.lbl_AdminStatus.text = "Not Verified by Admin"
        } else if self.sellerPropertiesArr[indexPath.row]["admin_status"] as? String == "7" {
            cell.lbl_AdminStatus.text = "Verified by Admin"
        } else if self.sellerPropertiesArr[indexPath.row]["admin_status"] as? String == "8" {
            cell.lbl_AdminStatus.text = "Rejected by Admin"
        }
        
        if let propCurrency = self.sellerPropertiesArr[indexPath.row]["currency_symbol"] as? String {
            currency = propCurrency
        }
        
        if let propPrice = self.sellerPropertiesArr[indexPath.row]["original_amount"] as? String {
            price = propPrice
        }
        
        cell.lbl_CreditAmount.text = currency + " " + price
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
}

class SellerPropertiesViewController: UIViewController {
    
    var sellerPropertiesArr = [[String:Any]]()

    @IBOutlet var tblvw_SellerProperties: UITableView!
    override func viewDidLoad() {
        
        self.getSellerProperties()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func getSellerProperties() {
        
        let user_id: Int =  UserDefaults.standard.integer(forKey: "user_id")
        
        let parameters : Parameters = [
            "seller_id": String(user_id),
            ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.sellerPropertyListURL, withParameters: parameters, withSuccess: { (response) in

            if response is [String: Any] {

                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool

                if success == true {
                    self.sellerPropertiesArr = Main_response["creditList"] as! [[String : Any]]

                    self.tblvw_SellerProperties.delegate = self
                    self.tblvw_SellerProperties.dataSource = self

                    self.tblvw_SellerProperties.reloadData()

                } else {
                    PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
                }
            }
        }) { (error) in
            print ("error \((String(describing: error!.localizedDescription)))")

            PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: (String(describing: error!.localizedDescription)), okBtnTitle: "OK", activityType: .show)
        }
    
    }
    
    @IBAction func addPropertiesBtnAction(_ sender: Any) {
        let vc = instantiateViewController(storyboardID: "AdvancePropertyDetailsViewController") as! AdvancePropertyDetailsViewController
        vc.pageFrom = "propertyList"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}

