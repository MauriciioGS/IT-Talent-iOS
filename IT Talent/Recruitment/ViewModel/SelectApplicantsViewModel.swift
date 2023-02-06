//
//  SelectApplicantsViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 05/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SelectApplicantsViewModel {
    
    private let db = Firestore.firestore()
    
    var fetchApplicants : (() -> ()) = { }
    
    private var applicants: [UserProfile] = []
    private var numApplicants: Int = 0
    
    var applicantsList: [UserProfile]? {
        didSet {
            fetchApplicants()
        }
    }
    
    func getAppplicantsByJob(_ applicants: [String]) {
        numApplicants = applicants.count-1
        print(numApplicants)
        applicants.forEach { userEmail in
            if !userEmail.isEmpty {
                self.db.collection("users").document(userEmail).getDocument { (document, error) in
                    if let document = document, document.exists {
                        DispatchQueue.main.async {
                            do {
                                let userProfile = try document.data(as: UserProfile.self)
                                self.applicants.append(userProfile)
                                if self.applicants.count == self.numApplicants {
                                    self.applicantsList = self.applicants
                                }
                            } catch {
                                print("Error en la decodificación: \(error)")
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    var fetchNewApplicants : (() -> ()) = { }
    
    var showSuccess: Bool? {
        didSet {
            fetchNewApplicants()
        }
    }
    
    func setNewStage(_ job: Job) {
        db.collection("jobs").document(job.id!).updateData([
            "applicants" : job.applicants,
            "status" : job.status
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                self.showSuccess = false
            } else {
                print("Document successfully updated")
                self.showSuccess = true
            }
        }
    }
}
