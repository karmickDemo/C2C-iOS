//
//  DashBoardViewController.swift
//  C2C
//
//  Created by Karmick on 06/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Crashlytics
import Alamofire


//MARK: UICollectionViewCell Connections

class DashBoardCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var lbl_HeadingName_Dashboard: UILabel!
    @IBOutlet var vw_bckgrd_cell: UIView!
    @IBOutlet var imgBtn_Dashboard: UIButton!
}

class DashBoardLongCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var lbl_HeadingName_Dashboard_long: UILabel!
    @IBOutlet var vw_bckgrd_cell_long: UIView!
    @IBOutlet var imgBtn_Dashboard_long: UIButton!
}

//MARK: UICollectionViewCell Layout/Cell Design

fileprivate let sectionInsets = UIEdgeInsets(top: 14.0, left: 14.0, bottom: 20.0, right: 14.0)
fileprivate let itemsPerRow: CGFloat = 2

extension DashBoardViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        if (Device.IS_IPHONE_5){
            print("iphone 5")
            return CGSize(width: widthPerItem, height: 110)
        }
        else
        {
            return CGSize(width: widthPerItem, height: 140)
        }
        
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    //MARK: UICollectionViewDelegate & UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDashboardContent.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if nameStr == "Buyer"
        {
            switch true {
                case indexPath.row == 5 || indexPath.row == 6 :  // do something
                    let cell :DashBoardLongCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardLongCollectionViewCell", for: indexPath) as? DashBoardLongCollectionViewCell
                    cell?.vw_bckgrd_cell_long.layer.cornerRadius = 4
                    cell?.vw_bckgrd_cell_long.clipsToBounds = true
                
                    cell?.lbl_HeadingName_Dashboard_long.text = arrDashboardContent [indexPath.row] ["labelText"] as? String
                    cell?.imgBtn_Dashboard_long.setImage(UIImage(named: (arrDashboardContent [indexPath.row] ["image"] as? String)! ) , for: UIControlState.normal)
                
                    if (Device.IS_IPHONE_5){
                        print("iphone 5")
                        cell?.lbl_HeadingName_Dashboard_long.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard_long.font.fontName)!, size: 11)
                    } else {
                        cell?.lbl_HeadingName_Dashboard_long.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard_long.font.fontName)!, size: 16)
                    }
                    print("font size===\(String(describing: cell?.lbl_HeadingName_Dashboard_long.font))")

                    return cell!
                
            // other cases
            default :
                let cell :DashBoardCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCollectionViewCell", for: indexPath) as? DashBoardCollectionViewCell
                cell?.vw_bckgrd_cell.layer.cornerRadius = 4
                cell?.vw_bckgrd_cell.clipsToBounds = true
                
                cell?.lbl_HeadingName_Dashboard.text = arrDashboardContent [indexPath.row] ["labelText"] as? String
                cell?.imgBtn_Dashboard.setImage(UIImage(named: (arrDashboardContent [indexPath.row] ["image"] as? String)! ) , for: UIControlState.normal)
                
                if (Device.IS_IPHONE_5){
                    print("iphone 5")
                    cell?.lbl_HeadingName_Dashboard.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard.font.fontName)!, size: 11)
                } else {
                    cell?.lbl_HeadingName_Dashboard.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard.font.fontName)!, size: 16)
                }
                return cell!
            }
        }
        else {
            
            switch true {
                case indexPath.row == 3 || indexPath.row == 4 :
                // do something
                    let cell :DashBoardLongCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardLongCollectionViewCell", for: indexPath) as? DashBoardLongCollectionViewCell
                    cell?.vw_bckgrd_cell_long.layer.cornerRadius = 4
                    cell?.vw_bckgrd_cell_long.clipsToBounds = true
                
                    cell?.lbl_HeadingName_Dashboard_long.text = arrDashboardContent [indexPath.row] ["labelText"] as? String
                    cell?.imgBtn_Dashboard_long.setImage(UIImage(named: (arrDashboardContent [indexPath.row] ["image"] as? String)! ) , for: UIControlState.normal)
                
                    if (Device.IS_IPHONE_5) {
                        print("iphone 5")
                        cell?.lbl_HeadingName_Dashboard_long.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard_long.font.fontName)!, size: 11)
                    } else {
                        cell?.lbl_HeadingName_Dashboard_long.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard_long.font.fontName)!, size: 16)
                    }
                
                    return cell!
                
            // other cases
            default :
                
                let cell :DashBoardCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCollectionViewCell", for: indexPath) as? DashBoardCollectionViewCell
                cell?.vw_bckgrd_cell.layer.cornerRadius = 4
                cell?.vw_bckgrd_cell.clipsToBounds = true
                
                cell?.lbl_HeadingName_Dashboard.text = arrDashboardContent [indexPath.row] ["labelText"] as? String
                cell?.imgBtn_Dashboard.setImage(UIImage(named: (arrDashboardContent [indexPath.row] ["image"] as? String)! ) , for: UIControlState.normal)
                
                if (Device.IS_IPHONE_5){
                    print("iphone 5")
                    cell?.lbl_HeadingName_Dashboard.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard.font.fontName)!, size: 11)
                } else {
                    cell?.lbl_HeadingName_Dashboard.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard.font.fontName)!, size: 16)
                }
                print("font size===\(String(describing: cell?.lbl_HeadingName_Dashboard.font))")

                return cell!
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
}

class DashBoardViewController: UIViewController {

    var arrDashboardContent  = [[String:Any]]()
    var nameStr = String()
    
    var controller: UIViewController = UIViewController()
    
    @IBOutlet var collectionVw: UICollectionView!
    
    let refreshControle = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarView?.backgroundColor = headerColor
        
        self.collectionVw.addSubview(refreshControle)
        
        UserDefaults.standard.bool(forKey: "PageType")
        UserDefaults.standard.integer(forKey: "PageType")
        UserDefaults.standard.string(forKey: "PageType")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController")
        
        self.getDashboardList()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.collectionVw {
            if self.refreshControle.isRefreshing {
                refreshTable();
            }
        }
    }
    
    func refreshTable() {
        self.refreshControle.endRefreshing();
        self.getDashboardList()
    }
    
    private func getDashboardList() {
        
        let user_id: Int =  UserDefaults.standard.integer(forKey: "user_id")
        let user_type: String = UserDefaults.standard.string(forKey: "user_type")!
        
        let parameter: Parameters = [
            "user_id": String(user_id),
            "user_type": user_type,
            ]
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.dashboardURL, withParameters: parameter, withSuccess: { (response) in
            
            let mainResponse = response as! [String: Any]
            let success = mainResponse["success"] as! Bool
            
            if success == true {
                
                var newDealCount: String = ""
                var confrmedDealCount: String = ""
                
                var acceptedOfferCount: String = ""
                var pendingOfferCount: String = ""
                var rejectedOfferCount: String = ""
                
                var newDealHeading: String = ""
                var confrmedDealHeading: String = ""
                
                var acceptedOfferHeading: String = ""
                var pendingOfferHeading: String = ""
                var rejectedOfferHeading: String = ""
                
                
                if let newDeal = mainResponse["new_deal_count"] as? Int {
                    newDealCount = String(newDeal)
                    
                    if newDeal > 1 {
                        newDealHeading = " New Deals"
                    } else {
                        newDealHeading = " New Deal"
                    }
                }
                if let confrmedDeal = mainResponse["confirm_deal_count"] as? Int {
                    confrmedDealCount = String(confrmedDeal)
                    
                    if confrmedDeal > 1 {
                        newDealHeading = " Confirmed Deals"
                    } else {
                        confrmedDealHeading = " Confirmed Deal"
                    }
                }
                
                if let acceptedOffer = mainResponse["accepted_offer_count"] as? Int {
                    acceptedOfferCount = String(acceptedOffer)
                    
                    if acceptedOffer > 1 {
                        acceptedOfferHeading = " Accepted Offers"
                    } else {
                        acceptedOfferHeading = " Accepted Offer"
                    }
                }
                if let pendingOffer = mainResponse["pending_offer_count"] as? Int {
                    pendingOfferCount = String(pendingOffer)
                    
                    if pendingOffer > 1 {
                        pendingOfferHeading = " Pending Offers"
                    } else {
                        pendingOfferHeading = " Pending Offer"
                    }
                }
                if let rejectedOffer = mainResponse["rejected_offer_count"] as? Int {
                    rejectedOfferCount = String(rejectedOffer)
                    
                    if rejectedOffer > 1 {
                        rejectedOfferHeading = " Rejected Offers"
                    } else {
                        rejectedOfferHeading = " Rejected Offer"
                    }
                }
                
                let offerStr: String = pendingOfferCount + pendingOfferHeading + "\n" + acceptedOfferCount + acceptedOfferHeading + "\n" + rejectedOfferCount + rejectedOfferHeading
                
                let dealStr: String = newDealCount + newDealHeading + "\n" + confrmedDealCount + confrmedDealHeading
                
                
                let dic1 = [
                    "labelText": "SEARCH CREDIT",
                    "image": "search-property",
                    ]
                let dic2 = [
                    "labelText": "WISHLIST",
                    "image": "wishlist",
                    ]
                let dic3 = [
                    "labelText": "MY TRANSACTIONS",
                    "image": "transaction",
                    ]
                let dic4 = [
                    "labelText": "COMMUNICATIONS",
                    "image": "chat",
                    ]
                let dic5 = [
                    "labelText": "PREFERENCES",
                    "image": "preference",
                    ]
                let dic7 = [
                    "labelText": offerStr,
                    "image": "offer",
                    ]
                let dic8 = [
                    "labelText": dealStr,
                    "image": "deals",
                    ]
                
                ///for seller
                
                let dic9 = [
                    "labelText": "MY CREDITS",
                    "image": "my-property",
                    ]
                let dic10 = [
                    "labelText": "MY TRANSACTIONS",
                    "image": "transaction",
                    ]
                let dic11 = [
                    "labelText": "COMMUNICATIONS",
                    "image": "chat",
                    ]
                let dic13 = [
                    "labelText": offerStr,
                    "image": "offer",
                    ]
                let dic14 = [
                    "labelText": dealStr,
                    "image": "deals",
                    ]
                
                self.nameStr =  UserDefaults.standard.string(forKey: "PageType")!
                print("namestring\(self.nameStr)")
                
                if self.nameStr == "Buyer"
                {
                    self.arrDashboardContent = [dic1, dic2, dic3, dic4, dic5, dic7, dic8]
                }
                else
                {
                    self.arrDashboardContent = [dic9, dic10, dic11, dic13, dic14]
                }
                
                self.collectionVw.dataSource=self
                self.collectionVw.delegate=self
                
                self.collectionVw.reloadData()
            }
            
        }) { (erorr) in
            
        }
    }

    
    @IBAction func menuClicked(_ sender: Any) {
        
        LeftMenuViewController.showLeftMenu(onParentViewController: self) { (_, _) in
        
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
   
}
