//
//  Job.swift
//  IT Talent
//
//  Created by Mauricio García S on 31/01/23.
//

import Foundation

public struct Job: Codable {
    var id: String?
    let job: String
    let enterprise: String
    let imageUrl: String
    let location: String
    let mode: String
    let type: String
    let wage: String
    let vacancies: String
    var applicants: [String]
    var emailRecruiter: String
    var nameRecruiter: String
    var timestamp: String
    var date: String
    var time: String
    var status: Int
    
    enum CodingKeys: String, CodingKey {
    case job
    case enterprise
    case imageUrl
    case location
    case mode
    case type
    case wage
    case vacancies
    case applicants
    case emailRecruiter
    case nameRecruiter
    case timestamp
    case date
    case time
    case status
    }
}
