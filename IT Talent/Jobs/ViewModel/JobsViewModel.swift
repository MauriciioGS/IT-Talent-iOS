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
    
    private var myJobs: [Job] = []
    
    var jobsList: [Job]? {
        didSet {
            fetchJobs()
        }
    }
    
    func getMyJobPosts() {
        if let userEmail = getUserLocal() {
            getJobsByUser(email: userEmail)
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
    
    func getJobsByUser(email: String) {
        print("Obteniendo jobs...")
        myJobs.removeAll()
        db.collection("jobs").whereField("emailRecruiter", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Deserializando...")
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        do {
                            var job = try document.data(as: Job.self)
                            job.id = document.documentID
                            self.myJobs.append(job)
                        } catch {
                            print("Error en la conversión: \(error)")
                        }
                    }
                    self.jobsList = self.myJobs
                }
            }
        }
    }
}
