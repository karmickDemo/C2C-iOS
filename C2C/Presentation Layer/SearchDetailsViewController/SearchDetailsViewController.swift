//
//  SearchDetailsViewController.swift
//  C2C
//
//  Created by Karmick on 09/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import UIKit
import Alamofire

class SearchDetailsCell: UITableViewCell {
    
    @IBOutlet var propertyNameLbl: UILabel!
    @IBOutlet var propertyDescriptionLbl: UILabel!
    @IBOutlet var propertyCountryLbl: UILabel!
    @IBOutlet var propertyPriceLbl: UILabel!
}

extension SearchDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchPropertyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchDetailsCell", for: indexPath) as! SearchDetailsCell
        
        if let propName = self.searchPropertyList[indexPath.row]["title"] as? String {
            cell.propertyNameLbl.text = propName
        }
        
        if let propDesc = self.searchPropertyList[indexPath.row]["description"] as? String {
            cell.propertyDescriptionLbl.text = propDesc
        }
        
        var country = String()
        var location = String()
        var currency = String()
        var price = String()
        
        if let countryName = self.searchPropertyList[indexPath.row]["country_name"] as? String {
            country = countryName
        }
        
        if let locName = self.searchPropertyList[indexPath.row]["region_name"] as? String {
            location = locName
        }
        
        cell.propertyCountryLbl.text = "Country" + " : " + country + " | " + "Location" + " : " + location
        
        if let propCurrency = self.searchPropertyList[indexPath.row]["currency_symbol"] as? String {
            currency = propCurrency
        }
        
        if let propPrice = self.searchPropertyList[indexPath.row]["original_amount"] as? String {
            price = propPrice
        }
        
        cell.propertyPriceLbl.text = currency + " " + price
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.user_id! != 0 {
            let vc = instantiateViewController(storyboardID: "ProductDetailsViewController") as! ProductDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            PopupTwoOptionsViewController.showPopUpTwoOptions(onParentViewController: self, alertText: "Alert", descriptionText: "Are you not loged in yet. please login to continue.", cancelBtnTitle: "CANCEL", okBtnTitle: "Log In", activityType: .notLogedin, selected: { (_, _) in })
        }
    }
}

class SearchDetailsViewController: UIViewController {

    var contentArr: [[String: Any]]!
    var qumulativeHeight = CGFloat()
    var parameterSearch: Parameters!
    
    var searchPropertyList = [[String: Any]]()
    
    @IBOutlet var serachDetailTableView: UITableView!
    @IBOutlet var headerContainerView: UIView!
    
    var user_id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIApplication.shared.statusBarView?.backgroundColor = headerColor
        
        self.drawTags(contains: contentArr)
        
        self.user_id =  UserDefaults.standard.integer(forKey: "user_id")
        
        self.serachProperties()
    }
    
    private func serachProperties () {
        
        ApiCallingClass.BaseApiCalling(withurlString: URLs.searchPropertyURL, withParameters: self.parameterSearch, withSuccess: { (response) in
            
            if response is [String: Any] {

                let Main_response = response as! [String: Any]
                let success = Main_response["success"] as! Bool
                
                if success == true{
                    self.searchPropertyList = Main_response["creditList"] as! [[String : Any]]
                    
                    self.serachDetailTableView.delegate = self
                    self.serachDetailTableView.dataSource = self
                    self.serachDetailTableView.reloadData()
                    
                } else {
                    
                }
            }
            
        }) { (error) in
            print ("error \((String(describing: error!.localizedDescription)))")
            
        }
    }
    
    func drawTags(contains: [[String: Any]]) -> Void {
        
        let startingPosX: CGFloat = 20.0
        let startinnPosY: CGFloat = 60.0
        let tagHeight: CGFloat = 30.0
        let spaceHorizontal: CGFloat = 5.0
        let spaceVertical: CGFloat = 4.0
        let paddingSpaceBottom: CGFloat = 20.0
        
        var qumulativeWidth: CGFloat = startingPosX
        qumulativeHeight = startinnPosY
        
        for i in (0..<contentArr.count) {
            
            let headingStr = contentArr[i]["placeholderText"] as! String
            let valueStr = contentArr[i]["text"] as! String
            
            let tagView = UIView()
            
            let sizeHeadingStr = self.stringWidth(str: headingStr, font: UIFont (name: "OpenSans-Semibold", size: 12)!)
            let sizevalueStr = self.stringWidth(str: valueStr, font: UIFont (name: "OpenSans", size: 12)!)
            
            var tagViewWidth = CGFloat()
            
            let space: CGFloat = (5.0 + 15.0 + 5.0 + 10.0 + 5.0)
            tagViewWidth =  space + (sizeHeadingStr + sizevalueStr)
            
            if tagViewWidth > (screenWidth - (2*startingPosX))
            {
                tagViewWidth = (screenWidth - (2*startingPosX))
            }
            
            tagView.frame = CGRect(x: qumulativeWidth, y: qumulativeHeight, width: CGFloat(tagViewWidth), height: tagHeight)
//            tagView.layer.borderWidth = 1
//            tagView.layer.borderColor = placeHolderColor.cgColor
            tagView.layer.cornerRadius = 2
            tagView.clipsToBounds = true
            tagView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
            let tagImage = UIImageView()
            tagImage.frame = CGRect (x: 5 ,y: (tagHeight-15)/2,width: 15.0, height: 15.0)
            tagImage.image = UIImage(named: contentArr[i]["image"] as! String)
            tagImage.contentMode = .scaleAspectFit
            
            let headingLbl = UILabel()
            headingLbl.frame = CGRect (x: 25.0,y: 0,width: sizeHeadingStr, height: tagHeight)
            headingLbl.font = UIFont (name: "OpenSans-Semibold", size: 12)
            headingLbl.textAlignment = .center
            headingLbl.text = headingStr
            headingLbl.textColor = placeHolderColor
            
            let middleLbl = UILabel()
            middleLbl.frame = CGRect (x: 25 + sizeHeadingStr,y: 0,width: 10, height: tagHeight)
            middleLbl.font = UIFont (name: "OpenSans", size: 12)
            middleLbl.text = ":"
            middleLbl.textAlignment = .center
            middleLbl.textColor = placeHolderColor
            
            let valueLbl = UILabel()
            valueLbl.frame = CGRect (x: 35 + sizeHeadingStr,y: 0,width: sizevalueStr, height: tagHeight)
            valueLbl.font = UIFont (name: "OpenSans", size: 12)
            valueLbl.textAlignment = .center
            valueLbl.text = valueStr
            valueLbl.textColor = placeHolderColor
            
            tagView.addSubview(tagImage)
            tagView.addSubview(headingLbl)
            tagView.addSubview(middleLbl)
            tagView.addSubview(valueLbl)
            
            self.headerContainerView .addSubview(tagView)
            
            if (contentArr.count == i+1) {
                qumulativeHeight = qumulativeHeight + tagHeight + spaceVertical;
            } else {
                
                let headingStrNext = contentArr[i+1]["placeholderText"] as! String
                let valueStrNext = contentArr[i+1]["text"] as! String
                
                let sizeHeadingStrNext = self.stringWidth(str: headingStrNext, font: UIFont (name: "OpenSans-Semibold", size: 12)!)
                let sizevalueStrNext = self.stringWidth(str: valueStrNext, font: UIFont (name: "OpenSans", size: 12)!)
                
                var tagviewWidthNext = CGFloat()
                
                let space: CGFloat = (5.0 + 15.0 + 5.0 + 10.0 + 5.0)
                tagviewWidthNext = space + (sizeHeadingStrNext + sizevalueStrNext)
                
                let widthRemaining: CGFloat = (screenWidth - (qumulativeWidth + tagViewWidth + startingPosX + spaceHorizontal));
                let nextWidth = tagviewWidthNext;
                
                if nextWidth >= widthRemaining
                {
                    qumulativeWidth = startingPosX;
                    qumulativeHeight = qumulativeHeight + tagHeight + spaceVertical;
                }
                else
                {
                    qumulativeWidth = qumulativeWidth + tagViewWidth + spaceHorizontal;
                }
                
                print("qumulativeHeight \(qumulativeHeight)")
            }
        }
        
        self.headerContainerView.frame = CGRect (x: 0, y: 0,width: screenWidth, height: qumulativeHeight + paddingSpaceBottom)
    }
    
    func stringWidth(str: String, font: UIFont) -> CGFloat {
        
        let stringRect = NSString(string: str).boundingRect(
            with: CGSize(width: screenWidth - 40, height: CGFloat(30)),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: font],
            context: nil).size
        return stringRect.width
    }
    
//    -(void)drawTagView:(UIView *)toView
//    {
//    float startingPosX = 15.0;
//    float startinnPosY = 40.0;
//    tagHeight = 20;
//    float spaceHorizontal = 10;
//    float spaceVertical = 10;
//    float qumulativeWidth = startingPosX;
//    qumulativeHeight = startinnPosY;
//
//    UIColor *selectedColorForTag = [UIColor colorWithRed:110.0f/255.0f green:98.0f/255.0f blue:222.0f/255.0f alpha:1];
//    UIColor *borderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
//    UIFont *textFont = [UIFont fontWithName:@"OpenSans-Semibold" size:12];
//
//    for (UIView *tagView in [toView subviews])
//    {
//    if (tagView.tag == 100)
//    {
//
//    }
//    else
//    {
//    [tagView removeFromSuperview];
//    }
//    }
//
//
//    for (int i=0 ; i<listArr.count ; i++)
//    {
//    CGSize constraintSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, 21);
//
//    CGRect messageRect = [[NSString stringWithFormat:@"%@    ",[[listArr objectAtIndex:i] valueForKey:@"key_name"]] boundingRectWithSize:constraintSize options:NSStringDrawingUsesFontLeading
//    |NSStringDrawingUsesLineFragmentOrigin|NSLineBreakByWordWrapping|NSLineBreakByCharWrapping attributes:@{NSFontAttributeName:textFont} context:nil];
//
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(qumulativeWidth, qumulativeHeight, messageRect.size.width, tagHeight)];
//    lbl.text = [[listArr objectAtIndex:i] valueForKey:@"key_name"];
//    lbl.font = [UIFont systemFontOfSize:11];
//    lbl.adjustsFontSizeToFitWidth = YES;
//    //        lbl.backgroundColor = [UIColor darkGrayColor];
//    lbl.textAlignment = NSTextAlignmentCenter;
//    lbl.layer.cornerRadius = tagHeight/2;
//
//    lbl.layer.borderWidth = 1.0f;
//    lbl.layer.borderColor = borderColor.CGColor;
//    lbl.clipsToBounds = YES;
//    lbl.textColor = selectedColorForTag;
//
//    if ([[[listArr objectAtIndex:i] allKeys] containsObject:@"is_matched"])
//    {
//    lbl.layer.borderColor = selectedColorForTag.CGColor;
//    lbl.backgroundColor = selectedColorForTag;
//    lbl.textColor = [UIColor whiteColor];
//    }
//
//    [toView addSubview:lbl];
//
//    if (listArr.count == i+1) {
//
//    }
//    else
//    {
//    CGSize constraintSizeNext = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, tagHeight);
//
//    CGRect messageRectNext = [[NSString stringWithFormat:@"%@    ",[[listArr objectAtIndex:i+1] valueForKey:@"key_name"]] boundingRectWithSize:constraintSizeNext options:NSStringDrawingUsesFontLeading
//    |NSStringDrawingUsesLineFragmentOrigin|NSLineBreakByWordWrapping|NSLineBreakByCharWrapping attributes:@{NSFontAttributeName:textFont} context:nil];
//
//    CGFloat widthRemaining = (([[UIScreen mainScreen] bounds].size.width)-(qumulativeWidth + messageRect.size.width + startingPosX + spaceHorizontal));
//    CGFloat nextWidth = messageRectNext.size.width;
//
//
//    if (nextWidth >= widthRemaining)
//    {
//    if (upDownBtnBool == true)
//    {
//    break;
//    }
//    else
//    {
//    qumulativeWidth = 15;
//    qumulativeHeight = qumulativeHeight + tagHeight + spaceVertical;
//    }
//
//    }
//    else
//    {
//    qumulativeWidth = qumulativeWidth + messageRect.size.width + spaceHorizontal;
//    }
//    }
//    }
//    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btn_Back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
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
