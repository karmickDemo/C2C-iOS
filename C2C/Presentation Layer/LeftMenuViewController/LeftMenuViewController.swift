//
//  LeftMenuViewController.swift
//  C2C
//
//  Created by Karmick on 12/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit


extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
    
        cell.iconImage.image = UIImage(named: contentArr[indexPath.row]["image"] as! String)
        cell.menuNameLbl.text = contentArr[indexPath.row]["text"] as? String
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.menuClosingForPush(withIndexPath: indexPath)
    }
}

class MenuCell: UITableViewCell {
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var menuNameLbl: UILabel!
}

class LeftMenuViewController: UIViewController {

    var contentArr = [[String: Any]]()
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var alphaView: UIView!
    @IBOutlet var menuContainerView: UIView!
    
    var viewController: UIViewController?
    
    var userType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.menuContainerView.transform = CGAffineTransform(translationX: -screenWidth * 0.7, y: 0)
        self.alphaView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        tapGesture.numberOfTapsRequired = 1
        self.alphaView.addGestureRecognizer(tapGesture)
        
    
        userType = UserDefaults.standard.string(forKey: "PageType")!
        
        if userType == "Buyer" {
            
            let dic1 = [
                "image": "dashboardMenu",
                "text": "Dashboard",
                ]
            let dic2 = [
                "image": "myprofileMenu",
                "text": "My Profile",
                ]
            let dic3 = [
                "image": "settingMenu",
                "text": "Settings",
                ]
            let dic4 = [
                "image": "changePwd",
                "text": "Change Password",
                ]
            let dic5 = [
                "image": "logoutMenu",
                "text": "Logout",
                ]
            
            contentArr = [dic1, dic2, dic3, dic4, dic5]
            
        } else if userType == "Seller" {
            let dic1 = [
                "image": "dashboardMenu",
                "text": "Dashboard",
                ]
            let dic2 = [
                "image": "myprofileMenu",
                "text": "My Profile",
                ]
            let dic3 = [
                "image": "changePwd",
                "text": "Change Password",
                ]
            let dic4 = [
                "image": "logoutMenu",
                "text": "Logout",
                ]
            
            contentArr = [dic1, dic2, dic3, dic4]
        }
        
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        
        self.menuTableView.reloadData()
    }
    
    
    
    static func showLeftMenu(onParentViewController parentViewController: UIViewController, selected: @escaping (_ value: AnyObject?, _ index: Int?) -> Void) {
        
        let presentViewController = UIStoryboard(name: "Main", bundle: nil)
        let classObj = presentViewController.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        
        classObj.showMenu(onParentViewController: parentViewController)
    }
    
    func showMenu(onParentViewController parentViewController: UIViewController) {
        
        self.view.frame = UIScreen.main.bounds
        UIApplication.shared.windows.first!.addSubview(self.view)
        parentViewController.addChildViewController(self)
        self.didMove(toParentViewController: parentViewController)
        parentViewController.view.bringSubview(toFront: self.view)
        
        viewController = parentViewController
        
        UIView.animate(withDuration: 0.3, animations: {
            self.menuContainerView.transform = .identity
            self.alphaView.alpha = 0.7
        }) { (_) in
            
        }
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.menuClosingGlobal()
    }
    
    @objc func closeMenu()
    {
        self.menuClosingGlobal()
    }
    
    func menuClosingGlobal() {
        UIView.animate(withDuration: 0.3, animations: {
            self.menuContainerView.transform = CGAffineTransform(translationX: -screenWidth * 0.8, y: 0)
            self.alphaView.alpha = 0
        }) { (_) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    func menuClosingForPush(withIndexPath indexPathForRow: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: {
            self.menuContainerView.transform = CGAffineTransform(translationX: -screenWidth * 0.8, y: 0)
            self.alphaView.alpha = 0
        }) { (_) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
            self.push(withIndexPath: indexPathForRow)
        }
    }
    
    func push(withIndexPath indexPath: IndexPath) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
