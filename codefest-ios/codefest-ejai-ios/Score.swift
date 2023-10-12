//
//  Score.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import Foundation

struct Score: Codable {
    
    var username: String
    var pnumber: String
    var total: Double 
}

extension Score: Identifiable {
    var id: String {
        pnumber
    }
}
