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
        success  <- map["success"]
        message  <- map["message"]
        data  <- map["data"]
    }
}

class UserData: Mappable{
    
    var id: String?
    var user_type: String?
    var first_name: String?
    var last_name: String?
    var company: String?
    var email: String?
    var city: String?
    var region_id: String?
    var country_id: String?
    var id_proof: String?
    var trade_licence: String?
    
    required init?(map: Map) {
        
        id = ""
        user_type = ""
        first_name = ""
        last_name = ""
        company = ""
        email = ""
        city = ""
        region_id = ""
        country_id = ""
        id_proof = ""
        trade_licence = ""
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        user_type <- map["user_type"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        company <- map["company"]
        email <- map["email"]
        city <- map["city"]
        region_id <- map["region_id"]
        country_id <- map["country_id"]
        id_proof <- map["id_proof"]
        trade_licence <- map["trade_licence"]
    }
}
