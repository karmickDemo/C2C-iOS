//
//  WishListViewController.swift
//  C2C
//
//  Created by Karmick on 27/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit

extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchDetailsCell", for: indexPath) as! SearchDetailsCell
        
        var country = String()
        var region = String()
        var creditType = String()
        var financialLoanType = String()
        var currency = String()
        var price = String()

        cell.propertyNameLbl.text = "1, 2 & 3 BHK RESIDENTIAL APARTMENTS AT KOLKATA"
        cell.propertyDescriptionLbl.text = "Karma builders presents first of its kinds group housing in Kolkata. Karma Country Homes gives you a chance to own your very own Holiday Homes in Kolkata"
        country = "India"
        region = "Asia"
        creditType = "Building"
        financialLoanType = "Bank"
        currency = "$"
        price = "455.00"
        
        cell.propertyCountryLbl.text = "Region" + " : " + region + " | " + "Country" + " : " + country + " | " + "Credit type" + " : " + creditType + " | " + "Financial loan type" + " : " + financialLoanType
        cell.propertyPriceLbl.text = currency + " " + price
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

class WishListViewController: UIViewController {

    @IBOutlet var tblvw_WishList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblvw_WishList.dataSource = self
        self.tblvw_WishList.delegate = self
        
        self.tblvw_WishList.rowHeight = UITableViewAutomaticDimension
        self.tblvw_WishList.estimatedRowHeight = 118
        self.tblvw_WishList.reloadData()

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
