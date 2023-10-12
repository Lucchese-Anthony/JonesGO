//
//  DataManager.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import Foundation

struct DataManager {
    static let defaults = UserDefaults.standard

    static var isLoggedIn: Bool {
        get {
            defaults.bool(forKey: #function)
        }
        set {
            defaults.setValue(newValue, forKey: #function)
        }
    }
    
    static var user: User? {
        get {
            guard let data = defaults.data(forKey: #function) else { return nil }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            guard 
                let newValue = newValue,
                let data = try? JSONEncoder().encode(newValue)
            else {
                return
            }
            defaults.setValue(data, forKey: #function)
        }
    }
    
    static var pointsOfInterest: [PointOfInterest] {
        get {
            guard let data = defaults.data(forKey: #function) else { return [] }
            return (try? JSONDecoder().decode([PointOfInterest].self, from: data)) ?? []
        }
        set {
            guard
                let data = try? JSONEncoder().encode(newValue)
            else {
                return
            }
            defaults.setValue(data, forKey: #function)
        }
    }
    
    static var scores: [Score] {
        get {
            guard let data = defaults.data(forKey: #function) else { return [] }
            return (try? JSONDecoder().decode([Score].self, from: data)) ?? []
        }
        set {
            guard
                let data = try? JSONEncoder().encode(newValue)
            else {
                return
            }
            defaults.setValue(data, forKey: #function)
        }
    }

    
}
