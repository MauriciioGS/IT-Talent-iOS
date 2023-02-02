//
//  TalentViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 01/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TalentViewModel {
    
    private let db = Firestore.firestore()

    var fetchTalentFiltered : (() -> ()) = { }
    
    private var talentFiltered: [UserProfile] = []
    
    var talentListFilter: [UserProfile]? {
        didSet {
            fetchTalentFiltered()
        }
    }
    
    func getTalentByProfRole(filterRole: String) {
        print("Obteniendo talento...")
        talentFiltered.removeAll()
        db.collection("users").whereField("profRole", isEqualTo: filterRole).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Deserializando...")
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        do {
                            var user = try document.data(as: UserProfile.self)
                            self.talentFiltered.append(user)
                        } catch {
                            print("Error en la conversión: \(error)")
                        }
                    }
                    self.talentListFilter = self.talentFiltered
                }
            }
        }
    }
    
    var fetchTalent : (() -> ()) = { }
    
    private var allTalent: [UserProfile] = []
    
    var talentList: [UserProfile]? {
        didSet {
            fetchTalent()
        }
    }
    
    func getAllTalent() {
        print("Obteniendo talento...")
        allTalent.removeAll()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Deserializando...")
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        do {
                            var user = try document.data(as: UserProfile.self)
                            if user.userType == 1 {
                                self.allTalent.append(user)
                            }
                        } catch {
                            print("Error en la conversión: \(error)")
                        }
                    }
                    self.talentList = self.allTalent
                }
            }
        }
    }

}
