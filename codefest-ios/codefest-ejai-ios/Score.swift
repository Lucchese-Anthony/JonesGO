//
//  Score.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import Foundation

struct Score: Codable {
    
    var userPointId: Int
    var userId: Int
    var pointId: Int
}

extension Score: Identifiable {
    var id: Int {
        userPointId
    }
}
