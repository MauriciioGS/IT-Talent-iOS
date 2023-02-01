//
//  NewJobViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 31/01/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class NewJobViewModel {
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    private var newJob : Job?
    private var user : User?
    
    var newJobUiState : (() -> ()) = { }
    
    var isSaved: Bool? {
        didSet {
            newJobUiState()
        }
    }
    
    var getUserUiState : (() -> ()) = { }
    
    var userEnterprise: String? {
        didSet {
            getUserUiState()
        }
    }
    
    func getUser(context: NSManagedObjectContext){
        self.mObjectContext = context
        do {
            user = try context.fetch(User.fetchRequest()).first
            db.collection("users").document((user?.email)!).getDocument(as: UserProfile.self) { result in
                switch result {
                case .success(let user):
                    self.userEnterprise = user.enterprise
                case .failure(let error):
                    print("Error obteniendo remote data: \(error)")
                }
            }
        } catch {
            print("Error obteniendo local data: \(error)")
        }
    }
    
    func saveNewJob(newJob: Job, context: NSManagedObjectContext) {
        self.mObjectContext = context
        self.newJob = newJob
        do {
            if let user = user {
                self.newJob?.nameRecruiter = user.fullName!
                self.newJob?.emailRecruiter = user.email!
                var ref: DocumentReference? = nil
                ref = try db.collection("jobs").addDocument(from: self.newJob) { err in
                    if let err = err {
                        self.isSaved = false
                        print("Error guardando los datos en el servidor: \(err.localizedDescription)")
                    } else {
                        self.isSaved = true
                    }
                }
            }
        } catch let error {
            print("Error obteniendo los datos locales: \(error.localizedDescription)")
        }
    }
    
}
