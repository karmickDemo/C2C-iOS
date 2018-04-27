//
//  File.swift
//  C2C
//
//  Created by Karmick on 09/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}
