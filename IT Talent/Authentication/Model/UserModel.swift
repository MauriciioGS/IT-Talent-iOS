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
    let fullName: String
    let country: String
    let city: String
    let age: Int
    let phoneNumber: String
    let resume: String
    let profRole: String
    let photoUrl: String
    let xpLevel: String
    let skills: [String]
    let experiences: [Experience]
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
