//
//  MyProfileViewController.swift
//  C2C
//
//  Created by Karmick on 09/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit

class MyProfileCell: UITableViewCell {
    
    @IBOutlet var headingImageView: UIImageView!
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
}

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myProfileCell", for: indexPath) as? MyProfileCell
        
        cell?.headingImageView!.image = UIImage(named:(contentArr[indexPath.row]["image"] as! String))
        cell?.headingLbl!.text = contentArr[indexPath.row]["heading"] as? String
        cell?.descriptionLbl!.text = contentArr[indexPath.row]["description"] as? String
        
        cell?.descriptionLbl!.sizeToFit()
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let sizeExpected = CGSize(width: screenWidth - 60, height: CGFloat(MAXFLOAT))
        let sizeFont = NSString(string: contentArr[indexPath.row]["description"] as! String).boundingRect(
            with: CGSize(width: screenWidth - 60, height: CGFloat(MAXFLOAT)),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: UIFont (name: "OpenSans", size: 14)!],
            context: nil).size
        
        return max(sizeFont.height, 22) + 20 + 22 + 5 + 20
    }

}

class MyProfileViewController: UIViewController {
    
    var contentArr = [[String: Any]]()
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var editProfileBtn: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let dic1 = ["image": "aboutme",
                    "heading": "About Me",
                    "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,"]
        
        let dic2 = ["image": "location",
                    "heading": "Location",
                    "description": "Saudi Arabia"]
        
        let dic3 = ["image": "email-1",
                    "heading": "Email-id",
                    "description": "somenath@gmail.com"]
        
        let dic4 = ["image": "phone",
                    "heading": "Phone No.",
                    "description": "1234567890"]
        
        contentArr = [dic1, dic2, dic3, dic4]
        
        UIApplication.shared.statusBarView?.backgroundColor = headerColor
        
        self.editProfileBtn.layer.cornerRadius = 22.5
        self.editProfileBtn.clipsToBounds = true
        
        self.profileImageView.layer.borderWidth = 2.0;
        self.profileImageView.layer.borderColor = fontColorDark.cgColor
        self.profileImageView.layer.cornerRadius = 55
        self.profileImageView.clipsToBounds = true
        
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        
        self.profileTableView.reloadData()
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        self.view.endEditing(true)
        LeftMenuViewController.showLeftMenu(onParentViewController: self) { (_, _) in
            
        }
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

}
