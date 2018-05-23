//
//  PopupListingViewController.swift
//  C2C
//
//  Created by Karmick on 18/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit

enum PopupType {
    case country
    case region
    case creditType
    case loanType
    case currency
    case sellerProperty
    case multipleOptions
}

class ListCell: UITableViewCell {
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var imageVw: UIImageView!
}

extension PopupListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        
        switch self.popupType {
        case .region:
                cell.nameLbl.text = contentArr[indexPath.row]["name"] as? String
            break
        case .country:
                cell.nameLbl.text = contentArr[indexPath.row]["name"] as? String
            break
        case .creditType:
            cell.nameLbl.text = contentArr[indexPath.row]["type_name"] as? String
            break
        case .loanType:
            cell.nameLbl.text = contentArr[indexPath.row]["type_name"] as? String
            break
        case .currency:
            cell.nameLbl.text = contentArr[indexPath.row]["currency_name"] as? String
            break
        case .sellerProperty:
            cell.nameLbl.text = contentArr[indexPath.row]["title"] as? String
            break
         case .multipleOptions:
            cell.nameLbl.text = contentArr[indexPath.row]["name"] as? String
            break
        default: break
            
        }
        
        switch self.popupType {
            
        case .multipleOptions:
            
            if self.selectedIndexArr.contains(indexPath) {
                cell.imageVw.image = UIImage (named: "tickList")
                cell.nameLbl.textColor = fontColorDark
            } else {
                cell.imageVw.image = UIImage (named: "tickListWhite")
                cell.nameLbl.textColor = placeHolderColor
            }
            break
        default:
            if contentArr[indexPath.row]["isSelected"] as! String == "selected" {
                cell.imageVw.image = UIImage (named: "tickList")
                cell.nameLbl.textColor = fontColorDark
            } else if contentArr[indexPath.row]["isSelected"] as! String == "notSelected" {
                cell.imageVw.image = UIImage (named: "tickListWhite")
                cell.nameLbl.textColor = placeHolderColor
            }
            break
        }
        
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.popupType {
            
        case .multipleOptions:
            
            if self.selectedIndexArr.contains(indexPath) {
                self.selectedIndexArr.remove(object: indexPath)
            } else {
                self.selectedIndexArr.append(indexPath)
            }
            break
        default:
            if contentArr[indexPath.row]["isSelected"] as! String == "selected" {
                var chunk = [String: Any]()
                chunk = contentArr[indexPath.row]
                contentArr.remove(at: indexPath.row)
                
                chunk["isSelected"] = "notSelected"
                contentArr.insert(chunk, at: indexPath.row)
                
            } else {
                contentArr = self.arrConfig(arr: contentArr)
                
                var chunk = [String: Any]()
                chunk = contentArr[indexPath.row]
                contentArr.remove(at: indexPath.row)
                
                chunk["isSelected"] = "selected"
                contentArr.insert(chunk, at: indexPath.row)
            }
            break
        }

        tableView.reloadData()
    }
}

class PopupListingViewController: UIViewController {
    
    var popupType: PopupType!
    
    var selectedIndexArr = [IndexPath]()

    @IBOutlet var alphaView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var listingTableView: UITableView!
    
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var okBtn: UIButton!
    
    var selectedIndex: IndexPath?
    
    var contentArr = [[String: Any]]()
    
    var viewController: UIViewController?
    
    var didSelect: ((_ selectedItem: String?, _ index: Int?) -> Void)?
    
    var didSelectIndexs: ((_ selectedIndexs: [IndexPath]?, _ index: Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.containerView.layer.cornerRadius = 15
        self.containerView.clipsToBounds = true
        
        self.cancelBtn.layer.cornerRadius = 4.0
        self.cancelBtn.clipsToBounds = true
        
        self.okBtn.layer.cornerRadius = 4.0
        self.okBtn.clipsToBounds = true
        
        self.alphaView.alpha = 0
        
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.alphaView.addGestureRecognizer(tap)
        self.alphaView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        self.cancelPopup()
    }
    
    static func showPopUpListing(onParentViewController parentViewController: UIViewController, heading headingText: String, selectedIndexForList selectedIndex: String,contents listArr: [[String: Any]], type: PopupType, selected: @escaping (_ value: String?, _ index: Int?) -> Void) {
        
        let classObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupListingViewController") as! PopupListingViewController
        classObj.popupListingConfig(onParentViewController: parentViewController, heading: headingText, selectedIndexForList: selectedIndex, selectedIndexArr: [], contents: listArr, type: type)
        classObj.didSelect = selected
//        classObj.popupType = type
    }
    
    static func showPopUpListingForMultipleOption(onParentViewController parentViewController: UIViewController, heading headingText: String, selectedIndexForList selectedIndex: [IndexPath],contents listArr: [[String: Any]], type: PopupType, selected: @escaping (_ selectedIndexs: [IndexPath]?, _ index: Int?) -> Void) {
        
        let classObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupListingViewController") as! PopupListingViewController
        classObj.popupListingConfig(onParentViewController: parentViewController, heading: headingText, selectedIndexForList: "",selectedIndexArr: selectedIndex, contents: listArr, type:type)
        classObj.didSelectIndexs = selected
//        classObj.popupType = type
    }

    func popupListingConfig (onParentViewController parentViewController: UIViewController, heading headingText: String, selectedIndexForList index: String, selectedIndexArr indexArr:[IndexPath], contents listArr: [[String: Any]], type: PopupType) -> Void {
        
        self.view.frame = UIScreen.main.bounds
        UIApplication.shared.windows.first!.addSubview(self.view)
        parentViewController.addChildViewController(self)
        self.didMove(toParentViewController: parentViewController)
        parentViewController.view.bringSubview(toFront: self.view)
        
        viewController = parentViewController
        self.popupType = type
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.alphaView.alpha = 0.7
            self.containerView.transform = .identity
        }) { _ in
            
        }
        
        self.headingLbl.text = headingText
        contentArr = listArr
        
        switch type {
        case .multipleOptions:
            self.selectedIndexArr = indexArr
            break
        default:
            selectedIndex = IndexPath(row: Int(index)!, section: 0)

            for i in 0..<contentArr.count {
                var chunk = [String: Any]()
                chunk = contentArr[i]
                contentArr.remove(at: i)

                if i == Int(index)! {
                    chunk["isSelected"] = "selected"
                } else {
                    chunk["isSelected"] = "notSelected"
                }

                contentArr.insert(chunk, at: i)
            }
            break
        }
        
        print("new arr : \(contentArr)")
        
        self.listingTableView.delegate = self
        self.listingTableView.dataSource = self
        
        self.listingTableView.reloadData()
    }
    
    private func arrConfig(arr: [[String: Any]]) -> [[String: Any]] {
        
        for i in 0..<contentArr.count {
            var chunk = [String: Any]()
            chunk = contentArr[i]
            contentArr.remove(at: i)
            
            chunk["isSelected"] = "notSelected"
            
            contentArr.insert(chunk, at: i)
        }
        return contentArr
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.cancelPopup()
    }
    
    @IBAction func okBtnAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            self.alphaView.alpha = 0
        }) { (_) in
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
            var row: Int = -1
            
            switch self.popupType {
                case .multipleOptions:
                break
                default:
                    
                    for i in 0..<self.contentArr.count {
                        
                        if self.contentArr[i]["isSelected"] as! String == "selected" {
                            row = i
                            break
                        }
                    }
                break
            }
            
            
            
            switch self.popupType {
            case .region:
                if row == -1 {
                    self.didSelect!("", row)
                } else {
                    self.didSelect!(self.contentArr[row]["name"] as? String, row)
                }
                break
            case .country:
                if row == -1 {
                    self.didSelect!("", row)
                } else {
                    self.didSelect!(self.contentArr[row]["name"] as? String, row)
                }
                break
            case .creditType:
                if row == -1 {
                    self.didSelect!("", row)
                } else {
                    self.didSelect!(self.contentArr[row]["type_name"] as? String, row)
                }
                break
            case .loanType:
                if row == -1 {
                    self.didSelect!("", row)
                } else {
                    self.didSelect!(self.contentArr[row]["type_name"] as? String, row)
                }
                break
            case .currency:
                if row == -1 {
                    self.didSelect!("", row)
                } else {
                    self.didSelect!(self.contentArr[row]["currency_name"] as? String, row)
                }
                break
            case .sellerProperty:
                if row == -1 {
                    self.didSelect!("", row)
                } else {
                    self.didSelect!(self.contentArr[row]["title"] as? String, row)
                }
                break
            case .multipleOptions:
                self.didSelectIndexs!(self.selectedIndexArr, 0)
                break
            default: break
            }
        }
    }
    
    private func cancelPopup() -> Void {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            self.alphaView.alpha = 0
        }) { (_) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
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
