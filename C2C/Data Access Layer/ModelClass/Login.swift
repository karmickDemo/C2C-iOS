//
//  Login.swift
//  C2C
//
//  Created by Karmick on 16/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Login:Mappable {
    
    var success:String?
    var message:String?
    var data:[UserData]
    
    required init?(map: Map) {
        success = ""
        message = ""
        data = []
    }
    
    func mapping(map: Map) {
        success   <- map["success"]
        message  <- map["message"]
        data    <- map["data"]
    }
}

class UserData: Mappable{
    
    var id: String?
    var user_type: String?
    var last_name: String?
    var company: String?
    var email: String?
    var mobile_no: String?
    var city: String?
    
    
    required init?(map: Map) {
        
        id = ""
        user_type = ""
        last_name = ""
        company = ""
        email = ""
        mobile_no = ""
        city = ""

    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        user_type <- map["user_type"]
        last_name <- map["last_name"]
        company <- map["company"]
        email <- map["Resource_Id"]
        mobile_no <- map["DayName"]
        city <- map["SlotEnd"]
    }
}
