//
//  TransactionViewController.swift
//  C2C
//
//  Created by Karmick on 26/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet var lbl_CreditTitle: UILabel!
    @IBOutlet var lbl_location: UILabel!
    @IBOutlet var lbl_DealAmount: UILabel!
    @IBOutlet var lbl_CommissionAmount: UILabel!
    @IBOutlet var lbl_PayToSellerAmount: UILabel!
    @IBOutlet var lbl_BankInfo: UILabel!
    @IBOutlet var lbl_Status: UILabel!
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        var bankInfo = String()
        var status = String()
        bankInfo = ""
        status = "Paid not done"
        cell.lbl_BankInfo.text = "Bank info : " + bankInfo
        cell.lbl_Status.text = "Status : " + status
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

class TransactionViewController: UIViewController {
    
    @IBOutlet var tblvw_Transaction: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblvw_Transaction.dataSource = self
        self.tblvw_Transaction.delegate = self
        
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

