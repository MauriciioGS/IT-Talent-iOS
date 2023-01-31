//
//  JobsViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 31/01/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class JobsViewModel {
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    
    init(_ context: NSManagedObjectContext? = nil) {
        self.mObjectContext = context
    }
    
    var fetchJobs : (() -> ()) = { }
    
    var jobsList: [Job]? {
        didSet {
            fetchJobs()
        }
    }
    
    func getMyJobPosts() {
        if let userEmail = getUserLocal() {
            let jobs = getJobsByUser(email: userEmail)
            jobsList = jobs
        } else {
            print("Error al obtener el usuario localmente")
        }
    }
    
    func getUserLocal() -> String? {
        do {
            let getUser = try mObjectContext?.fetch(User.fetchRequest())
            if let userData = getUser?.first {
                return userData.email
            } else {
                return nil
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    func getJobsByUser(email: String) -> [Job] {
        var myJobs: [Job] = []
        db.collection("jobs").whereField("emailRecruiter", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        myJobs.append(try document.data(as: Job.self))
                    } catch {
                        print("Error en la conversión: \(error)")
                    }
                }
            }
        }
        return myJobs
    }
}
