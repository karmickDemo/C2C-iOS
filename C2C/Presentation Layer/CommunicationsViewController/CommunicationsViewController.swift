//
//  CommunicationsViewController.swift
//  C2C
//
//  Created by Karmick on 12/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
class CommunicationsTableViewCell: UITableViewCell
{
        @IBOutlet var lbl_PropertyName: UILabel!
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension CommunicationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mCommunicationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommunicationsTableViewCell", for: indexPath) as! CommunicationsTableViewCell
        
        mCommunicationsTableViewCell.selectionStyle = .none
        return mCommunicationsTableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 74
        
    }
}

class CommunicationsViewController: UIViewController {
    
    @IBOutlet var adminMsgBtn: UIButton!
    @IBOutlet var sellerMessageBtn: UIButton!
    @IBOutlet var chatBtn: UIButton!
    

    @IBOutlet var tblvw_communication: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adminMsgBtn.titleLabel?.lineBreakMode = .byWordWrapping
        self.adminMsgBtn.titleLabel?.textAlignment = .left
        
        self.sellerMessageBtn.titleLabel?.lineBreakMode = .byWordWrapping
        self.sellerMessageBtn.titleLabel?.textAlignment = .left
        
        self.chatBtn.titleLabel?.lineBreakMode = .byWordWrapping
        self.chatBtn.titleLabel?.textAlignment = .center
        
        self.adminMsgBtn.setTitle("Admin \nMessages", for: .normal)
        self.sellerMessageBtn.setTitle("Seller \nMessages", for: .normal)
        self.chatBtn.setTitle("Chats", for: .normal)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func btn_Back_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)

    }
    
    @IBAction func btn_Chats_Clicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mAdministrativeMessagesViewController = storyBoard.instantiateViewController(withIdentifier: "AdministrativeMessagesViewController") as! AdministrativeMessagesViewController
        self.navigationController?.pushViewController(mAdministrativeMessagesViewController, animated: false)

    }
}
