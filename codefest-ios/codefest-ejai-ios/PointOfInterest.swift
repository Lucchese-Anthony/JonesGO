//
//  PointOfInterest.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import Foundation

struct PointOfInterest: Codable {
    var id: String
    var name: String

}

extension PointOfInterest: Identifiable {
}
