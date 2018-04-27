//
//  Utility.swift
//  C2C
//
//  Created by Karmick on 05/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import Foundation
import UIKit

public let screenWidth = UIScreen.main.bounds.width
public let screenHeight = UIScreen.main.bounds.height

public let fontColorDark = UIColor(red:26/255, green:26/255, blue:26/255, alpha:1)
public let placeHolderColor = UIColor(red:133/255, green:133/255, blue:133/255, alpha: 1)
public let headerColor = UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1)

struct Device {
    // iDevice detection code
    
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}

func instantiateViewController(storyboardID: String) -> UIViewController {
    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardID)
    return viewController
}

