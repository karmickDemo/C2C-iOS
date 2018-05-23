//
//  Urls.swift
//  C2C
//
//  Created by Karmick on 13/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import Foundation


class URLs {
    
//    static let mainURL = "http://192.168.1.22/croom/api/"
//    static let mainURL = "http://karmickdev.com/croom/api/"
    static let mainURL = "http://www.editoutsource.com/croom/api/"
    
    static let loginURL = mainURL + "login"
    static let registrationBuyerURL = mainURL + "buyer_register"
    static let registrationSellerURL = mainURL + "seller_register"
    static let regionURL = mainURL + "get_region"
    static let countryURL = mainURL + "get_country_by_region_id"
    static let countryWithoutRegionURL = mainURL + "get_countries"
    static let propertyTypeURL = mainURL + "get_property_type"
    static let loanTypeURL = mainURL + "get_loan_type"
    static let currencyURL = mainURL + "get_currency_type"
    static let insertNewProperty = mainURL + "insert_new_property_details"
    static let searchPropertyURL = mainURL + "get_property_list"
    static let sellerPropertyListURL = mainURL + "get_property_list_byseller"
    static let changePasswordURL = mainURL + "chnage_password"
    static let getPrefferencesURL = mainURL + "get_prefferences"
    static let updatePreferenceURL = mainURL + "update_preference"
    static let getSettingsURL = mainURL + "get_settings"
    static let updateSettingsURL = mainURL + "update_settings"
    static let creditDetailURL = mainURL + "credit_details"
    static let addOfferURL = mainURL + "add_edit_offer"
    static let addRemoveWishlistURL = mainURL + "add_remove_wishlist"
    static let wishlistURL = mainURL + "wishlist"
    static let dashboardURL = mainURL + "getdashboard"
    static let editProfileURL = mainURL + "update_profile_details"
    static let myProfileURL = mainURL + "myProfile"
    static let getOfferSellerListURL = mainURL + "getOfferList"
    static let getOfferBuyerListURL = mainURL + "getOfferBuyerList"
    static let getBuyerDealListURL = mainURL + "getBuyerDealList"
    static let getSellerDealListURL = mainURL + "getSellerDealList"
    static let offerAcceptURL = mainURL + "offer_accept"
    static let offerRejectURL = mainURL + "offer_reject"
    static let getBuyerTransactionListURL = mainURL + "getBuyerTransactionList"
    static let getSellerTransactionListURL = mainURL + "getSellerTransactionList"
    static let buyerMessageListURL = mainURL + "get_msg_list"
    static let logoutURL = mainURL + "logout"
    static let sendMessageURL = mainURL + "message"
    static let forgotPasswordURL = mainURL + "forgotPasswordRecovery"
    
}
