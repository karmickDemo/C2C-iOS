//
//  DealListingViewController.swift
//  C2C
//
//  Created by Karmick on 27/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit

extension DealListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerPropertiesCell", for: indexPath) as! SellerPropertiesCell
        
        //if let propName = self.sellerPropertiesArr[indexPath.row]["title"] as? String {
        cell.lbl_CreditName.text = "1, 2 & 3 BHK Residential Apartments at Kolkata"
        //}
        
        var currencyDeal = String()
        var priceDeal = String()
        currencyDeal = "$"
        priceDeal = "44.78"
        
        let attrs1 = [NSAttributedStringKey.font : UIFont(name:  (cell.lbl_PropertyType.font.fontName), size: 13), NSAttributedStringKey.foregroundColor : UIColor(red:133/255, green:133/255, blue:133/255, alpha:1)]
        
        let attrs2 = [NSAttributedStringKey.font : UIFont(name:  (cell.lbl_PropertyType.font.fontName), size: 13), NSAttributedStringKey.foregroundColor : UIColor(red:120/255, green:186/255, blue:245/255, alpha:1)]
        
        let attributedString1 = NSMutableAttributedString(string:"Deal amount : ", attributes:(attrs1 as Any as! [NSAttributedStringKey : Any]))
        let attributedString2 = NSMutableAttributedString(string: currencyDeal + " " + priceDeal, attributes:(attrs2 as Any as! [NSAttributedStringKey : Any]))
        attributedString1.append(attributedString2)
        
        cell.lbl_PropertyType.attributedText = attributedString1
        cell.lbl_CreditAmount.text =  "Rejected"
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
}

class DealListingViewController: UIViewController {

    @IBOutlet var tblvw_DealListing: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblvw_DealListing.dataSource = self
        self.tblvw_DealListing.delegate = self

        // Do any additional setup after loading the view.
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
 
    @IBAction func btn_Back_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)

    }
    
}
