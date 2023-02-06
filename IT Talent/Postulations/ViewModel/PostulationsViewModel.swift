//
//  PostulationsViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 06/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class PostulationsViewModel {
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    init(_ context: NSManagedObjectContext? = nil) {
        self.mObjectContext = context
    }
    
    var fetchActivePostul : (() -> ()) = { }
    
    private var myActivePostul: [Job] = []
    private var myPastPostul: [Job] = []
    
    var activePostul: [Job]? {
        didSet {
            fetchActivePostul()
        }
    }
    var pastPostul: [Job]? {
        didSet {
            fetchActivePostul()
        }
    }
    
    func getMyActivePostul() {
        if let userEmail = getUserLocal() {
            getPostulByUser(userEmail: userEmail)
        } else {
            print("Error al obtener el usuario localmente")
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
            print("Error: \(error)")
        }
        return nil
    }
    
    private func getPostulByUser(userEmail: String) {
        print("Obteniendo postulaciones...")
        myActivePostul.removeAll()
        db.collection("jobs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Deserializando...")
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        do {
                            var job = try document.data(as: Job.self)
                            if job.status == 4 {
                                job.applicants.forEach { email in
                                    if userEmail == email {
                                        job.id = document.documentID
                                        self.myPastPostul.append(job)
                                        print(job.job)
                                        return
                                    }
                                }
                            } else{
                                job.applicants.forEach { email in
                                    if userEmail == email {
                                        job.id = document.documentID
                                        self.myActivePostul.append(job)
                                        return
                                    }
                                }
                            }
                        } catch {
                            print("Error en la conversión: \(error)")
                        }
                    }
                    self.activePostul = self.myActivePostul
                    self.pastPostul = self.myPastPostul
                }
            }
        }
    }
    
}
