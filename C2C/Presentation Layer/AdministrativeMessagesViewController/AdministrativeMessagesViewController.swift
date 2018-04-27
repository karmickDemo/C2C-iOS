//
//  AdministrativeMessagesViewController.swift
//  C2C
//
//  Created by Karmick on 16/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

//MARK: UITableViewCell Connections
class LeftSideChatTableViewCell: UITableViewCell
{
    @IBOutlet var lbl_Message_left: UILabel!
    @IBOutlet var vw_bckgrdCell_leftt: UIView!
    
}

class RightSideChatTableViewCell: UITableViewCell
{
    @IBOutlet var lbl_Message_right: UILabel!
    
    @IBOutlet var vw_bckgrdCell_right: UIView!
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension AdministrativeMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrChatDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 1
        {
            let mRightSideCell = tableView.dequeueReusableCell(withIdentifier: "RightSideChatTableViewCell", for: indexPath) as! RightSideChatTableViewCell
            mRightSideCell.vw_bckgrdCell_right.layer.cornerRadius = 14
            mRightSideCell.vw_bckgrdCell_right.clipsToBounds = true
            mRightSideCell.lbl_Message_right!.text = arrChatDetails[indexPath.row]["labeltext"] as? String
            // mRightSideCell.lbl_Message_right.sizeToFit()
            
            mRightSideCell.selectionStyle = .none
            mRightSideCell.setNeedsLayout()
            mRightSideCell.layoutIfNeeded()
            return mRightSideCell
        }
        else
        {
            let mLeftSideCell = tableView.dequeueReusableCell(withIdentifier: "LeftSideChatTableViewCell", for: indexPath) as! LeftSideChatTableViewCell
            
            mLeftSideCell.vw_bckgrdCell_leftt.layer.cornerRadius = 14
            mLeftSideCell.vw_bckgrdCell_leftt.clipsToBounds = true
            mLeftSideCell.lbl_Message_left!.text = arrChatDetails[indexPath.row]["labeltext"] as? String
            //  mLeftSideCell.lbl_Message_left.sizeToFit()
            
            mLeftSideCell.selectionStyle = .none
            mLeftSideCell.setNeedsLayout()
            mLeftSideCell.layoutIfNeeded()
            
            return mLeftSideCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row % 2 == 1
        {
            let mRightSideCell = tableView.dequeueReusableCell(withIdentifier: "RightSideChatTableViewCell", for: indexPath) as! RightSideChatTableViewCell
            mRightSideCell.vw_bckgrdCell_right.translatesAutoresizingMaskIntoConstraints = true
            
            mRightSideCell.lbl_Message_right!.text = arrChatDetails[indexPath.row]["labeltext"] as? String
            
            let fl: CGFloat = CGFloat((mRightSideCell.lbl_Message_right.text! as NSString).doubleValue)
            
            
            mRightSideCell.vw_bckgrdCell_right = UIView(frame: CGRect(x: UIScreen.main.bounds.width + 180 - 15 , y: 0, width: 0, height: UITableViewAutomaticDimension))
            // max(UIScreen.main.bounds.width + 180 +  fl - 15, 0)
        }
        else
        {
            let mLeftSideCell = tableView.dequeueReusableCell(withIdentifier: "LeftSideChatTableViewCell", for: indexPath) as! LeftSideChatTableViewCell
            mLeftSideCell.vw_bckgrdCell_leftt.translatesAutoresizingMaskIntoConstraints = true
            
            mLeftSideCell.lbl_Message_left!.text = arrChatDetails[indexPath.row]["labeltext"] as? String
            
            let fl: CGFloat = CGFloat((mLeftSideCell.lbl_Message_left.text! as NSString).doubleValue)
            
            
            mLeftSideCell.vw_bckgrdCell_leftt = UIView(frame: CGRect(x: 15 , y: 0, width: max(UIScreen.main.bounds.width + 180 +  fl - 15, 0), height: UITableViewAutomaticDimension))
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
        
    }
    
    
}


class AdministrativeMessagesViewController: UIViewController,UITextViewDelegate
{
    @IBOutlet var vw_bckgrd_msgtyping: UIView!
    @IBOutlet var vw_bckgrd_txtfld: UIView!
    @IBOutlet var lbl_Placeholder_txtvw: UILabel!
    @IBOutlet var txtvw_MessageType: UITextView!
    @IBOutlet var tblvw_Chat: UITableView!
    @IBOutlet var bottom_Constraint_Msgvw: NSLayoutConstraint!
    
    @IBOutlet var btn_send: UIButton!
    @IBOutlet var height_constraint_Msgvw: NSLayoutConstraint!
    
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var height_constraint_txtvwBck: NSLayoutConstraint!
    var keyboardHeight = CGFloat()
    var keyboardReturned = Bool()
    var keyboardHeightBackup = CGFloat()
    var arrChatDetails = [[String: Any]]()
    var chat_text_string = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
        self.txtvw_MessageType.delegate = self
        self.tblvw_Chat.delegate=self;
        self.tblvw_Chat.dataSource=self;
        self.vw_bckgrd_txtfld.layer.cornerRadius = 4
        self.vw_bckgrd_txtfld.clipsToBounds = true
        //self.txtvw_MessageType.sizeToFit()
        
        // self.txtvw_MessageType.resignFirstResponder()
        chat_text_string = self.txtvw_MessageType.text;
        self.txtvw_MessageType.text = ""
        self.lbl_Placeholder_txtvw.isHidden = !self.txtvw_MessageType.text.isEmpty
        self.btn_send.alpha = 0.45
        self.btn_send.isUserInteractionEnabled = false
        
        
        
        let dic1 = ["labeltext": "Hello"]
        
        let dic2 = ["labeltext": " Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"]
        
        let dic3 = ["labeltext": "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain."]
        
        let dic4 = ["labeltext": "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. "]
        
        let dic5 = ["labeltext": " Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"]
        
        let dic6 = ["labeltext": "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain."]
        
        arrChatDetails = [dic1,dic2,dic3,dic4,dic5,dic6]
        
        self.tblvw_Chat.rowHeight = UITableViewAutomaticDimension
        self.tblvw_Chat.estimatedRowHeight = 61
        self.tblvw_Chat.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardReturned = false
        self.txtvw_MessageType.contentOffset = CGPoint.zero
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.txtvw_MessageType.setContentOffset(CGPoint.zero, animated: false)
        self.txtvw_MessageType.contentSize = CGSize(width: self.txtvw_MessageType.frame.size.width, height: self.txtvw_MessageType.frame.size.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        print(keyboardHeight)
        
        if(keyboardHeightBackup == 0)
        {
            print("1st time...")
            
            keyboardHeightBackup = keyboardHeight
            self.view.layoutIfNeeded()
            self.bottom_Constraint_Msgvw.constant = keyboardHeight
            self.view.layoutIfNeeded()
            keyboardReturned = false;
        }
        else
        {
            print("2nd time...")
            
            keyboardHeightBackup = 0
            self.view.layoutIfNeeded()
            self.bottom_Constraint_Msgvw.constant = 0.0
            self.view.layoutIfNeeded()
            self.tblvw_Chat.reloadData()
        }
    }
    
    @objc func adjustFrames()
    {
        
        // let sizeThatShouldFitTheContent = self.txtvw_MessageType.sizeThatFits(CGSize(width: self.txtvw_MessageType.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        ///or
        
        let fixedWidth = self.txtvw_MessageType.frame.size.width
        self.txtvw_MessageType.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.txtvw_MessageType.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.txtvw_MessageType.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        // self.txtvw_MessageType.frame = newFrame
        
        if newSize.height > 100
        {
            
        }
        else
        {
            if newSize.height>36
            {
                textViewHeightConstraint.constant = newSize.height;
                print("height\(newSize.height)")
                height_constraint_Msgvw.constant=newSize.height+10;
                print("height_constraint_Msgvw=\(newSize.height+10)")
                self.bottom_Constraint_Msgvw.constant = keyboardHeight;
            }
        }
    }
    
    
    
    
    // MARK: - UIButton Actions
    @IBAction func btn_MessageSend_Click(_ sender: Any)
    {
        self.txtvw_MessageType.resignFirstResponder()
        bottom_Constraint_Msgvw.constant = 0
        self.self.txtvw_MessageType.text = ""
        self.lbl_Placeholder_txtvw.isHidden = !self.txtvw_MessageType.text.isEmpty
        self.btn_send.alpha = 0.45
        self.btn_send.isUserInteractionEnabled = false;
        height_constraint_Msgvw.constant = 60.0
        height_constraint_txtvwBck.constant = 44.0
    }
    
    @IBAction func btn_Back_Clicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension AdministrativeMessagesViewController: UITextFieldDelegate {
    // MARK: - UItextViewDelegate Methods
    
    
    internal func textViewDidBeginEditing(_ textView: UITextView)
    {
        keyboardReturned = true
        self.adjustFrames()
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView)
    {
        
        if (!self.txtvw_MessageType.hasText) {
            self.lbl_Placeholder_txtvw.isHidden = !self.txtvw_MessageType.text.isEmpty
            if self.lbl_Placeholder_txtvw.isHidden {
                
            }
            else{
                self.btn_send.alpha = 0.45
                self.btn_send.isUserInteractionEnabled = false;
            }
        }
    }
    
    
    public func textViewDidChange(_ textView: UITextView)
    {
        self.lbl_Placeholder_txtvw.isHidden = !self.txtvw_MessageType.text.isEmpty
        if self.lbl_Placeholder_txtvw.isHidden {
            self.btn_send.alpha = 1
            self.btn_send.isUserInteractionEnabled = true;
        }
        else{
            self.btn_send.alpha = 0.45
            self.btn_send.isUserInteractionEnabled = false;
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //        if (text == "\n") {
        //            if  (text == "") {
        //                self.txtvw_MessageType.resignFirstResponder()
        //                // bottom_Constraint_Msgvw.constant = 0
        //                // self.btn_send.alpha = 0.45
        //                self.btn_send.isUserInteractionEnabled = false;
        //                 height_constraint_Msgvw.constant = 60.0
        //                 height_constraint_txtvwBck.constant = 44.0
        //                //    return false
        //                 keyboardReturned = true
        //            }
        //            else if (text == "\n")
        //            {
        //                if textView.hasText{
        //                    self.adjustFrames()
        //                    return true
        //                }
        //                else{
        //                    self.txtvw_MessageType.resignFirstResponder()
        //                }
        //
        //            }
        //            else{
        //                self.txtvw_MessageType.text = String(format: "%@\n",chat_text_string)
        //                self.adjustFrames()
        //                print("hello")
        //            }
        //
        //            return false
        //        }
        //        else{
        //            self.adjustFrames()
        //            return true
        //        }
        
        if (text == "\n") {
            if ((self.txtvw_MessageType.text == "\n") || (self.txtvw_MessageType.text == "")){
                keyboardReturned = true
                self.txtvw_MessageType.resignFirstResponder()
            }
            else{
                self.txtvw_MessageType.text = String(format: "%@\n",self.txtvw_MessageType.text)
                self.adjustFrames()
            }
            return false
        }
        if textView.hasText == false{
            self.txtvw_MessageType.contentSize = CGSize(width: self.txtvw_MessageType.frame.size.width, height: self.txtvw_MessageType.frame.size.height)
            self.btn_send.alpha = 0.45
            self.btn_send.isUserInteractionEnabled = false;
            self.adjustFrames()
            return true
        }
        self.adjustFrames()
        return true
        
    }
    
}

