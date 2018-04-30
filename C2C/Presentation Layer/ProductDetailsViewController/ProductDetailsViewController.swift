//
//  ProductDetailsViewController.swift
//  C2C
//
//  Created by Karmick on 10/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let itemsPerRow: CGFloat = 2

class PropertyHighlightsCell: UITableViewCell {
    
    @IBOutlet var highlightCollectionView: UICollectionView!

    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var contentLblOne: UILabel!
    @IBOutlet var contentLblTwo: UILabel!
    
}

class PropertyImageCell: UITableViewCell {
    
    @IBOutlet var imageCollectionView: UICollectionView!
}

class ImageCell : UICollectionViewCell {
    
    @IBOutlet var propertyImage: UIImageView!
}

class HiglightInfoCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var contentLbl: UILabel!
}

class ListingTableViewCell : UITableViewCell {
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var scopeLbl: UILabel!
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 // for property image collection view
        {
            return CGSize(width: screenWidth, height: 250)
            
        } else if collectionView.tag == 2 {  // for highlights collection view
            
            let paddingSpace = 20 * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            
            
            let str = contentArr[indexPath.row]["text"] as! String
            let height: CGFloat = self.stringHeight(str: str, font: UIFont(name:"OpenSans", size: 12)!, size: CGSize(width: (screenWidth - 60)/2, height: CGFloat(MAXFLOAT)))
            let contentHeight = max(height, 20) + 20
            
            return CGSize(width: widthPerItem, height: contentHeight)
            
        } else {
            let size: CGSize = CGSize(width: 0, height: 0)
            return size
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 { // for property image collection view
            
            return 4
            
        } else if collectionView.tag == 2 {  // for highlights collection view
            
            return 8
            
        } else {
            
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 // for property image collection view
        {
            let cell :ImageCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell
            cell?.propertyImage.image = UIImage(named:"propertyImage")
            return cell!
            
        } else if collectionView.tag == 2 {  // for highlights collection view
            
            let cell :HiglightInfoCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "higlightInfoCollectionViewCell", for: indexPath) as? HiglightInfoCollectionViewCell
            cell?.headingLbl.text = "Floor area"
            cell?.contentLbl.text = contentArr[indexPath.item]["text"] as? String
            
            
            return cell!
            
        } else {
            
            let cell :UICollectionViewCell = UICollectionViewCell()
            return cell
        }
        
        
    }
    
    
}

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 250
        }
        else if indexPath.section == 1 {
            
            let str = contentArr[indexPath.row]["text"] as! String
            let height: CGFloat = self.stringHeight(str: str, font: UIFont(name:"OpenSans", size: 14)!, size: CGSize(width: screenWidth - 72, height: CGFloat(MAXFLOAT)))
            return max(height, 22) + 22
            
        } else if indexPath.section == 2 {
            
            var indexOne = 0
            var indexTwo = 0
            
            var heightOne: CGFloat = 0.0
            var heightTwo: CGFloat = 0.0
            
            if contentArr.count % 2 == 0 {
                
                indexOne = (indexPath.row * 2)
                indexTwo = (indexPath.row * 2) + 1
                
                heightOne = self.stringHeight(str: contentArr[indexOne]["text"] as! String, font: UIFont(name: "OpenSans", size: 12)!, size: CGSize(width: (screenWidth - 60)/2, height: CGFloat(MAXFLOAT)))
                heightTwo = self.stringHeight(str: contentArr[indexTwo]["text"] as! String, font: UIFont(name: "OpenSans", size: 12)!, size: CGSize(width: (screenWidth - 60)/2, height: CGFloat(MAXFLOAT)))
                
            } else {
                
                indexOne = (indexPath.row * 2)
                
                heightOne = self.stringHeight(str: contentArr[indexOne]["text"] as! String, font: UIFont(name: "OpenSans", size: 12)!, size: CGSize(width: (screenWidth - 60)/2, height: CGFloat(MAXFLOAT)))
            }
            
            return max(heightOne, heightTwo) + 20 + 20
            
        } else {
            
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return contentArr.count
        } else if section == 2 {
            return contentArr.count/2
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "propertyImageCell", for: indexPath) as! PropertyImageCell
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "listingTableViewCell", for: indexPath) as! ListingTableViewCell
            cell.selectionStyle = .none
            cell.scopeLbl?.text = contentArr[indexPath.row]["text"] as? String
            cell.iconImage?.image = UIImage(named:"tick")
            return cell
            
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "propertyHighlightsCell", for: indexPath) as! PropertyHighlightsCell
            cell.selectionStyle = .none
            
            if contentArr.count % 2 == 0 {
                
                cell.view1.isHidden = false
                cell.view2.isHidden = false
                
            } else {
                
                cell.view1.isHidden = false
                cell.view2.isHidden = true
            }
            
            let indexOne = (indexPath.row * 2)
            let indexTwo = (indexPath.row * 2) + 1
            
            cell.contentLblOne.text = contentArr[indexOne]["text"] as? String
            cell.contentLblTwo.text = contentArr[indexTwo]["text"] as? String
            
            
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
            
        } else {
            
            let cell: UITableViewCell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let strHeight: CGFloat = self.stringHeight(str: titleStr, font: UIFont(name:"OpenSans-Bold", size: 15)!, size: CGSize(width: screenWidth - 40, height: CGFloat(MAXFLOAT)))
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y:0, width: screenWidth, height: strHeight + 70)
            headerView.backgroundColor = UIColor.white
            
            let headingLbl = UILabel()
            headingLbl.frame = CGRect(x: 20, y: 20, width: screenWidth - 40, height: strHeight)
            headingLbl.text = titleStr
            headingLbl.textColor = fontColorDark
            headingLbl.numberOfLines = 0
            headingLbl.lineBreakMode = .byWordWrapping
            headingLbl.font = UIFont(name:"OpenSans-Bold", size: 15)!
            
            
            var creditType = String()
            var LoanType = String()
            
            if let property = self.creditInfo["property_type_name"] as? String {
                creditType = property
            }
            
            if let loan = self.creditInfo["financial_loan_type_name"] as? String {
                LoanType = loan
            }
            
            let subHeadingLbl = UILabel()
            subHeadingLbl.frame = CGRect(x: 20, y: 30 + strHeight, width: screenWidth - 40, height: 20)
            subHeadingLbl.textColor = placeHolderColor
            subHeadingLbl.font = UIFont(name:"OpenSans", size: 14)!
            subHeadingLbl.text = creditType + " | " + LoanType
            
            let locImg = UIImageView()
            locImg.frame = CGRect(x: 20, y: 60 + strHeight, width: 20, height: 20)
            locImg.image = UIImage(named: "location_detail")
            locImg.contentMode = .scaleAspectFit
            
            var region = String()
            var country = String()
            
            if let reg = self.creditInfo["region_name"] as? String {
                region = reg
            }
            
            if let countryProp = self.creditInfo["country_name"] as? String {
                country = countryProp
            }
            
            let locationLbl = UILabel()
            locationLbl.frame = CGRect(x: 50, y: 60 + strHeight, width: screenWidth - 70, height: 20)
            locationLbl.text = region + " " + country
            locationLbl.textColor = placeHolderColor
            locationLbl.font = UIFont(name:"OpenSans", size: 14)!
            
            let priceImg = UIImageView()
            priceImg.frame = CGRect(x: 20, y: 90 + strHeight, width: 20, height: 20)
            priceImg.image = UIImage(named: "doller")
            priceImg.contentMode = .scaleAspectFit
            
            let priceLbl = UILabel()
            priceLbl.frame = CGRect(x: 50, y: 90 + strHeight, width: screenWidth - 70, height: 20)
            if let price = self.creditInfo["original_amount"] as? String {
                priceLbl.text = price
            }
            priceLbl.textColor = placeHolderColor
            priceLbl.font = UIFont(name:"OpenSans", size: 14)!
            
            headerView.addSubview(headingLbl)
            headerView.addSubview(subHeadingLbl)
            headerView.addSubview(locImg)
            headerView.addSubview(locationLbl)
            headerView.addSubview(priceImg)
            headerView.addSubview(priceLbl)
            
            return headerView
            
        } else if section == 1 {
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y:0, width: screenWidth, height: 60)
            headerView.backgroundColor = UIColor.white
            
            let headingLbl = UILabel()
            headingLbl.frame = CGRect(x: 20, y: 20, width: screenWidth - 40, height: 20)
            headingLbl.text = "Project Details"
            headingLbl.textColor = fontColorDark
            
            headingLbl.font = UIFont(name:"OpenSans-Semibold", size: 14)!
            headerView.addSubview(headingLbl)
            
            return headerView
            
        } else if section == 2 {
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y:0, width: screenWidth, height: 170)
            headerView.backgroundColor = UIColor.white
            
            let containerView = UIView()
            containerView.frame = CGRect(x: 20, y:20, width: screenWidth - 40, height: 90)
            containerView.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha:1)
            
            let sellerImageView = UIImageView()
            sellerImageView.frame = CGRect(x: 10, y:10, width: 70, height: 70)
            sellerImageView.contentMode = .scaleAspectFill
            sellerImageView.image = UIImage(named: "placeholder")
            sellerImageView.layer.cornerRadius = 35
            sellerImageView.clipsToBounds = true
            
            let sellerNameLbl = UILabel()
            sellerNameLbl.frame = CGRect(x: 90, y:25, width: screenWidth - 140, height: 20)
            sellerNameLbl.text = "Casper"
            sellerNameLbl.textColor = fontColorDark
            sellerNameLbl.font = UIFont(name:"OpenSans-Bold", size: 14)!
            
            let sellerCompNameLbl = UILabel()
            sellerCompNameLbl.frame = CGRect(x: 90, y:45, width: screenWidth - 140, height: 20)
            sellerCompNameLbl.text = "Company name"
            sellerCompNameLbl.textColor = fontColorDark
            sellerCompNameLbl.font = UIFont(name:"OpenSans", size: 14)!
            
            let haedingLbl = UILabel()
            haedingLbl.frame = CGRect(x: 20, y:130, width: screenWidth - 40, height: 20)
            haedingLbl.text = "Business Highlights"
            haedingLbl.textColor = fontColorDark
            haedingLbl.font = UIFont(name:"OpenSans-Semibold", size: 14)!
            
            
            containerView.addSubview(sellerImageView)
            containerView.addSubview(sellerNameLbl)
            containerView.addSubview(sellerCompNameLbl)
            headerView.addSubview(containerView)
            headerView.addSubview(haedingLbl)
            
            return headerView
        }
        else {
            let v = UIView()
            return v
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            
            return self.stringHeight(str: titleStr, font: UIFont(name:"OpenSans-Bold", size: 15)!, size: CGSize(width: screenWidth - 40, height: CGFloat(MAXFLOAT))) + 130
            
        } else if section == 1 {
            
            return 60.0
            
        } else if section == 2 {
            
            return 170.0
        }
        else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func stringHeight(str: String, font: UIFont, size: CGSize) -> CGFloat {
        
        let stringRect = NSString(string: str).boundingRect(
            with: size,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: font],
            context: nil).size
        return stringRect.height
    }
    
}

class ProductDetailsViewController: UIViewController {
    
    let height: CGFloat = 0.0

    var titleStr: String! = ""
    
    @IBOutlet var productDetailTableView: UITableView!
    var contentArr = [[String: Any]]()
    
    @IBOutlet var mapImageView: UIImageView!
    
    var creditId: String!
    
    var creditDetails = [String: Any]()
    var creditInfo = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIApplication.shared.statusBarView?.backgroundColor = headerColor
        
        self.productDetailTableView.estimatedRowHeight = 44.0
        self.productDetailTableView.rowHeight = UITableViewAutomaticDimension
        
        let dic1 = [
            "text": "Lorem Ipsum",
            ]
        let dic2 = [
            "text": "Lorem Ipsum is simply dummy text of the printing",
            ]
        let dic3 = [
            "text": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
            ]
        let dic4 = [
            "text": "Lorem Ipsum is simply dummy text",
            ]
        let dic5 = [
            "text": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
            ]
        let dic6 = [
            "text": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
            ]
        let dic7 = [
            "text": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
            ]
        let dic8 = [
            "text": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
            ]
        
        contentArr = [dic1, dic2, dic3, dic4, dic5, dic6, dic7, dic8]
        
        self.mapImageView.layer.borderWidth = 5
        self.mapImageView.layer.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha:1).cgColor
        self.mapImageView.clipsToBounds = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.productDetailTableView.contentInsetAdjustmentBehavior = .never
        
        self.getCreditDetails()
    }
    
    private func getCreditDetails() {
        
        let user_id: Int =  UserDefaults.standard.integer(forKey: "user_id")
        
        let parameter: Parameters = [
            "credit_id": self.creditId,
            "user_id": String(user_id)
        ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.creditDetailURL, withParameters: parameter, withSuccess: { (response) in
            let Main_response = response as! [String: Any]
            let success = Main_response["success"] as! Bool
            
            if success == true {
                
                self.creditDetails = Main_response["creditList"] as! [String: Any]
                
                let creditInfoArr = self.creditDetails["credit"] as! [[String: Any]]
                self.creditInfo = creditInfoArr[0]
                
                self.titleStr = self.creditInfo["title"] as! String
                
                self.productDetailTableView.isHidden = false
                
                self.productDetailTableView.reloadData()
            } else {
                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: Main_response["message"] as! String, okBtnTitle: "OK", activityType: .show)
            }
        }) { (error) in
            if (error)?.errorCode == -200 {
                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Not connected", descriptionText: "Device is not connected to internet.", okBtnTitle: "OK", activityType: .show)
            } else {
                PopupOneOptionViewController.showPopUpOneOptions(onParentViewController: self, alertText: "Failed", descriptionText: error!.localizedDescription, okBtnTitle: "OK", activityType: .show)
            }
        }
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
