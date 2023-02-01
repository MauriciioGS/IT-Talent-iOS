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
    
    var newJobUiState : (() -> ()) = { }
    
    var isSaved: Bool? {
        didSet {
            newJobUiState()
        }
    }
    
    func saveNewJob(newJob: Job, context: NSManagedObjectContext) {
        self.mObjectContext = context
        self.newJob = newJob
        do {
            if let user = try context.fetch(User.fetchRequest()).first {
                self.newJob?.nameRecruiter = user.fullName!
                self.newJob?.emailRecruiter = user.email!
                var ref: DocumentReference? = nil
                ref = try db.collection("jobs").addDocument(from: self.newJob) { err in
                    if let err = err {
                        self.isSaved = false
                        print("Error guardando los datos en el servidor: \(err.localizedDescription)")
                    } else {
                        self.isSaved = true
                        print("Job Guardado!")
                    }
                }
            }
        } catch let error {
            print("Error obteniendo los datos locales: \(error.localizedDescription)")
        }
    }
    
}
