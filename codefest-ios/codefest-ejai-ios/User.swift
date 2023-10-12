//
//  User.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import Foundation

struct User: Codable {
    
    var username: String
    var pnumber: String
}

extension User: Identifiable {
    var id: String {
        pnumber
    }
}
