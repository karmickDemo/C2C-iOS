//
//  PopupActionSheetStyleViewController.swift
//  C2C
//
//  Created by Karmick on 07/05/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit

enum Activity {
    case sellerProperties
}

class PopupCell: UITableViewCell {
    
    @IBOutlet var imageOption: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    
}

class PopupActionSheetStyleViewController: UIViewController {

    @IBOutlet var alphaView: UIView!
    @IBOutlet var popupTableView: UITableView!
    @IBOutlet var popupTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var popupContainerView: UIView!
    @IBOutlet var popupContainerHeightConstraint: NSLayoutConstraint!
    
    var viewController: UIViewController?
    
    var itemArr = [[String: Any]]()
    
    var activityType: Activity!
    
    var didSelectRow: ((_ selectedItem: String?, _ index: Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alphaView.alpha = 0
        self.popupContainerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.alphaView.addGestureRecognizer(tap)
        self.alphaView.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        self.cancelPopup()
    }
    
    private func cancelPopup() -> Void {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.popupContainerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            self.alphaView.alpha = 0
        }) { (_) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    static func showPopUpOptions(onParentViewController parentViewController: UIViewController, itemArr: [[String: Any]], headingText: String, activityType: Activity, selected: @escaping (_ value: String?, _ index: Int?) -> Void) {
        
        let classObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupActionSheetStyleViewController") as! PopupActionSheetStyleViewController
        classObj.popupConfigaration (onParentViewController: parentViewController, nameArr: itemArr, headingText: headingText)
        classObj.activityType = activityType
        classObj.didSelectRow = selected
    }
    
    private func popupConfigaration (onParentViewController parentViewController: UIViewController, nameArr: [[String: Any]], headingText: String){
        
        self.view.frame = UIScreen.main.bounds
        UIApplication.shared.windows.first!.addSubview(self.view)
        parentViewController.addChildViewController(self)
        self.didMove(toParentViewController: parentViewController)
        parentViewController.view.bringSubview(toFront: self.view)
        
        viewController = parentViewController
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.alphaView.alpha = 0.7
            self.popupContainerView.transform = .identity
        }) { _ in
            
        }

        self.itemArr = nameArr
        
        let estimatedRow: Int = Int((screenHeight - ( 55 * 3 )) / 55)
        
        self.view.layoutIfNeeded()
        
        if self.itemArr.count > estimatedRow {
            self.popupTableViewHeightConstraint.constant = CGFloat(estimatedRow * 55)
            self.popupContainerHeightConstraint.constant = CGFloat(estimatedRow * 55)
            
            self.popupTableView.isScrollEnabled = true
        } else {
            self.popupTableViewHeightConstraint.constant = CGFloat(self.itemArr.count * 55)
            self.popupContainerHeightConstraint.constant = CGFloat(self.itemArr.count * 55)
            
            self.popupTableView.isScrollEnabled = false
        }
        
        self.popupTableView.delegate = self
        self.popupTableView.dataSource = self
        
        self.popupTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PopupActionSheetStyleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popupCell", for: indexPath) as! PopupCell
        cell.titleLbl.text = itemArr[indexPath.row]["title"] as? String
        cell.imageOption.image = UIImage(named: (itemArr[indexPath.row]["image"] as? String)!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.activityType {
        case .sellerProperties:
            
            let title = self.itemArr[indexPath.row]["title"] as! String
            
            UIView.animate(withDuration: 0.3, animations: {
                self.popupContainerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
                self.alphaView.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                self.didSelectRow!(title, indexPath.row)
            }
        
            break
        default:
            break
        }
    }

}
