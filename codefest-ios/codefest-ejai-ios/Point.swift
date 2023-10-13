//
//  PointOfInterest.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import MapKit
import SwiftUI

struct Point: Codable {
    var pointId: Int
    var points: Int
    var latitude: String
    var longitude: String
    var cooldown: Int
    var description: String

}

extension Point: Identifiable {
    var id: Int {
        pointId
    }
    
    var lat: CLLocationDegrees {
        let multiplier: CLLocationDegrees = latitude.last == "S" ? -1 : 1
        let number = CLLocationDegrees(latitude.split(separator: " ").first ?? "0") ?? 0
        return number * multiplier
    }
    
    var long: CLLocationDegrees {
        let multiplier: CLLocationDegrees = longitude.last == "W" ? -1 : 1
        let number = CLLocationDegrees(longitude.split(separator: " ").first ?? "0") ?? 0
        return number * multiplier
    }
    
    var location2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
}
    
   




