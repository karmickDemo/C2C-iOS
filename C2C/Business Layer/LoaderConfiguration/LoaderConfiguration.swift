//
//  LoaderConfiguration.swift
//  C2C
//
//  Created by Karmick on 13/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import Foundation
import SDLoader

class SDLoaderConfiguration {
    static let sdLoader = SDLoader()
    static func loaderConfig()
    {
        sdLoader.spinner?.lineWidth = 5
        sdLoader.spinner?.spacing = 0.2
        sdLoader.spinner?.sectorColor = UIColor.white.cgColor
        sdLoader.spinner?.textColor = UIColor.white
        sdLoader.spinner?.animationType = AnimationType.clockwise
    }
    
}
