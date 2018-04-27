//
//  SnackBarConfiguration.swift
//  C2C
//
//  Created by Karmick on 16/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import Foundation
import TTGSnackbar

class TTGSnackbarConfiguration {
    
    static func snackbarConfiguration(message messageStr: String, duration durartion: TTGSnackbarDuration)
    {
        let snackbar = TTGSnackbar(message: messageStr, duration: durartion)
        snackbar.contentInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
        snackbar.animationType = .slideFromTopBackToTop
        snackbar.show()
    }
    
}
