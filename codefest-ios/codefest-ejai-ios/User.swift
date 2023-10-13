//
//  User.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import Foundation

struct User: Codable {

    var userName: String
    var pnumber: String
    var user_id: Int
    
    
}

extension User: Identifiable {
    var id: Int {
        user_id
    }
    var score: Int {
        Int.random(in: 10...100)
    }
}
