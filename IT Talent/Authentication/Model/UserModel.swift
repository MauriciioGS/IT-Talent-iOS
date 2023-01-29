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
    var age: Int
    var phoneNumber: String
    var resume: String
    var profRole: String
    var photoUrl: String
    var xpLevel: String
    var skills: [String]
    var experiences: [Experience]?
    
    // Recruiter
    var enterprise: String
    var role: String
    
    var store: String = "App Store"
}

public struct Experience: Codable {
    let charge: String
    let enterprise: String
    let city: String
    let mode: String
    let type: String
    let period: String
    let yearsXp: Int
    let nowadays: Bool
    let achievements: String
}
