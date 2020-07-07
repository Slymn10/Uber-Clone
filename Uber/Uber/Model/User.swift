//
//  User.swift
//  Uber
//
//  Created by Süleyman Koçak on 12.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//
import CoreLocation

enum AccountType:Int{
    case passenger
    case driver
}

struct User {
    let fullname:String
    let email:String
    var accountType:AccountType!
    var location:CLLocation?
    let uid : String
    init(uid:String,dict:[String:Any]) {
        self.uid = uid
        self.fullname = dict["fullname"] as! String
        self.email = dict["email"] as! String


        if let index = dict["accountType"] as? Int{
            self.accountType = AccountType(rawValue: index)!
        }
    }
}
