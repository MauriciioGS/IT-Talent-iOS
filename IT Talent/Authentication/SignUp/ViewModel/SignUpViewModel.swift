//
//  SignUpViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 28/01/23.
//

import Foundation

class SignUpViewModel {
    
    var userProfile: UserProfile?
    
    func saveProfesional(userType: Int, email: String, name: String, profRole: String, profLevel: String) {
        userProfile = UserProfile(userType: userType, email: email, fullName: name, country: "", city: "", age: 0, phoneNumber: "", resume: "", profRole: profRole, photoUrl: "", xpLevel: profLevel, skills: [""], enterprise: "", role: "")
    }
    
    func saveRecruiter(enterprise: String, role: String) {
        userProfile?.enterprise = enterprise
        userProfile?.role = role
    }
}
