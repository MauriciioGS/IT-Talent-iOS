//
//  ApplyJobViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 04/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class ApplyJobViewModel {
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    init(_ context: NSManagedObjectContext? = nil) {
        self.mObjectContext = context
    }
    
    private var job: Job?
    
    var applyJobUIStatus : (() -> ()) = { }
    
    var isApplied: Bool? {
        didSet {
            applyJobUIStatus()
        }
    }
    
    func applyJob(job: Job) {
        self.job = job
        if let applicantEmail = getUserLocal() {
            setNewApplicant(applicantEmail)
        } else {
            print("Error al obtener el usuario localmente")
            self.isApplied = false
        }
    }
    
    private func getUserLocal() -> String? {
        do {
            let getUser = try mObjectContext?.fetch(User.fetchRequest())
            if let userData = getUser?.first {
                return userData.email
            } else {
                return nil
            }
        } catch {
            print("Error obteniendo localmente: \(error)")
        }
        return nil
    }
    
    private func setNewApplicant(_ applicantEmail: String) {
        job!.applicants.append(applicantEmail)
        db.collection("jobs").document(job!.id!).updateData([
            "applicants" : job!.applicants
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                self.isApplied = false
            } else {
                print("Document successfully updated")
                self.isApplied = true
            }
        }
    }
}
