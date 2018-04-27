//
//  DashBoardViewController.swift
//  C2C
//
//  Created by Karmick on 06/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Crashlytics


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
                    cell?.lbl_HeadingName_Dashboard.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard.font.fontName)!, size: 12)
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
                        cell?.lbl_HeadingName_Dashboard_long.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard_long.font.fontName)!, size: 13)
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
                    cell?.lbl_HeadingName_Dashboard.font = UIFont(name:  (cell?.lbl_HeadingName_Dashboard.font.fontName)!, size: 13)
                }
                print("font size===\(String(describing: cell?.lbl_HeadingName_Dashboard.font))")

                return cell!
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if nameStr == "Buyer"
        {
            switch true {
                case indexPath.row == 0 :
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let mDashBoardViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                    self.navigationController?.pushViewController(mDashBoardViewController, animated: false)
                    break
                case indexPath.row == 1 :
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let mWishListViewController = storyBoard.instantiateViewController(withIdentifier: "WishListViewController") as! WishListViewController
                    self.navigationController?.pushViewController(mWishListViewController, animated: false)
                    break
                case indexPath.row == 2 :
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let mTransactionViewController = storyBoard.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
                    self.navigationController?.pushViewController(mTransactionViewController, animated: false)
                    break
                case indexPath.row == 3 :
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let mDashBoardViewController = storyBoard.instantiateViewController(withIdentifier: "CommunicationsViewController") as! CommunicationsViewController
                    self.navigationController?.pushViewController(mDashBoardViewController, animated: false)
                    break
                case indexPath.row == 4 :
                    let mSetPreferencesViewController = instantiateViewController(storyboardID: "SetPreferencesViewController") as! SetPreferencesViewController
                    self.navigationController?.pushViewController(mSetPreferencesViewController, animated: false)
                    break
                case indexPath.row == 5 :
                    let mMyOffersViewController = instantiateViewController(storyboardID: "MyOffersViewController") as! MyOffersViewController
                    self.navigationController?.pushViewController(mMyOffersViewController, animated: false)
                    break
            default :
                let mDealListingViewController = instantiateViewController(storyboardID: "DealListingViewController") as! DealListingViewController
                self.navigationController?.pushViewController(mDealListingViewController, animated: false)
                break
            }
        } else {
            
            switch true
            {
            case indexPath.row == 0 :
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let mSellerPropertiesViewController = storyBoard.instantiateViewController(withIdentifier: "SellerPropertiesViewController") as! SellerPropertiesViewController
                self.navigationController?.pushViewController(mSellerPropertiesViewController, animated: false)
                break
            case indexPath.row == 1 :
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let mTransactionViewController = storyBoard.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
                self.navigationController?.pushViewController(mTransactionViewController, animated: false)
                break
                
            case indexPath.row == 2 :
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let mDashBoardViewController = storyBoard.instantiateViewController(withIdentifier: "CommunicationsViewController") as! CommunicationsViewController
                self.navigationController?.pushViewController(mDashBoardViewController, animated: false)
                break
                
            case indexPath.row == 3 :
                let mMyOffersViewController = instantiateViewController(storyboardID: "MyOffersViewController") as! MyOffersViewController
                self.navigationController?.pushViewController(mMyOffersViewController, animated: false)
                break
            default :
                let mDealListingViewController = instantiateViewController(storyboardID: "DealListingViewController") as! DealListingViewController
                self.navigationController?.pushViewController(mDealListingViewController, animated: false)
                break
            }
            
        }
        
    }
}

class DashBoardViewController: UIViewController {

    var arrDashboardContent  = [[String:Any]]()
    var nameStr = String()
    
    var controller: UIViewController = UIViewController()
    
    @IBOutlet var collectionVw: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarView?.backgroundColor = headerColor
        
        let dic1 = [
            "labelText": "SEARCH PROPERTY",
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
//        let dic6 = [
//            "labelText": "SETTINGS",
//            "image": "setting",
//            ]
        let dic7 = [
            "labelText": "5 NEW OFFERS\n2 PENDING OFFERS\n1 REJECTED OFFER",
            "image": "offer",
            ]
        let dic8 = [
            "labelText": "4 NEW DEALS\n2 CONFIRMED DEALS",
            "image": "deals",
            ]
        
        ///for seller
        
        let dic9 = [
            "labelText": "MY PROPERTIES",
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
//        let dic12 = [
//            "labelText": "SETTINGS",
//            "image": "setting",
//            ]
        let dic13 = [
            "labelText": "5 NEW OFFERS\n2 PENDING OFFERS\n1 REJECTED OFFER",
            "image": "offer",
            ]
        let dic14 = [
            "labelText": "4 NEW DEALS\n2 CONFIRMED DEALS",
            "image": "deals",
            ]
        
        UserDefaults.standard.bool(forKey: "PageType")
        UserDefaults.standard.integer(forKey: "PageType")
        UserDefaults.standard.string(forKey: "PageType")
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController")
        
        nameStr =  UserDefaults.standard.string(forKey: "PageType")!
        print("namestring\(nameStr)")
        
        if nameStr == "Buyer"
        {
            arrDashboardContent = [dic1, dic2, dic3, dic4, dic5, dic7, dic8]
        }
        else
        {
            arrDashboardContent = [dic9, dic10, dic11, dic13, dic14]
        }
    
        self.collectionVw.dataSource=self
        self.collectionVw.delegate=self
        
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
