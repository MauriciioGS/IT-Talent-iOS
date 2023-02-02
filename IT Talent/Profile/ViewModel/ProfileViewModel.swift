//
//  ProfileViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 02/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class ProfileViewModel{
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    var fetchUserProfile : (() -> ()) = { }
    
    var userProfile: UserProfile? {
        didSet {
            fetchUserProfile()
        }
    }
    
    func getUser(context: NSManagedObjectContext){
        self.mObjectContext = context
        do {
            if let userLocal = try context.fetch(User.fetchRequest()).first {
                db.collection("users").document((userLocal.email)!).getDocument(as: UserProfile.self) { result in
                    switch result {
                    case .success(let user):
                        self.userProfile = user
                    case .failure(let error):
                        print("Error obteniendo remote data: \(error)")
                    }
                }
            }
        } catch {
            print("Error obteniendo local data: \(error)")
        }
    }
}
