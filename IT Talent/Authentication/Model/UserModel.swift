//
//  UserModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import Foundation

public struct UserProfile: Codable {
    let userType: Int
    let email: String
    var fullName: String
    var country: String
    var city: String
    var phoneNumber: String
    var resume: String
    var profRole: String
    var xpLevel: String
    var skills: [String]
    var experiences: [Experience] = []
    
    // Recruiter
    var enterprise: String
    var role: String
    
    var store: String = "App Store"
    
    enum CodingKeys: String, CodingKey {
        case userType
        case email
        case fullName
        case country
        case city
        case phoneNumber
        case resume
        case profRole
        case xpLevel
        case skills
        case experiences
        case enterprise
        case role
        case store
    }
}

public struct Experience: Codable {
    let charge: String
    let enterprise: String
    let city: String
    let mode: String
    let type: String
    let period: String
    let yearsXp: Int
    let achievements: String
    
    enum CodingKeys: String, CodingKey {
        case charge
        case enterprise
        case city
        case mode
        case type
        case period
        case yearsXp
        case achievements
    }
}
