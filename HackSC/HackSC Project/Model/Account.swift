//
//  Account.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit

struct Account {
    
    // Attributes
    var email: String = ""
    var username: String {
        var username = ""
        for letter in email {
            if letter == "@" {
                return username
            } else {
                username = username + String(letter)
            }
        }
        return username
    }
    var displayName: String = ""
    var type: String = ""
    
    // Methods
    func getEmail() -> String { return email }
    func getUsername() -> String { return username }
    func getDisplayName() -> String { return displayName }
    func getType() -> String { return type }
    mutating func setEmail(_ e: String) { email = e }
    mutating func setType(_ t: String) { type = t }
    mutating func setDisplayName(_ d: String) { displayName = d }
    
}
