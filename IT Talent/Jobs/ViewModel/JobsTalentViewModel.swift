//
//  JobsTalentViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 03/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class JobsTalentViewModel {
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    init(_ context: NSManagedObjectContext? = nil) {
        self.mObjectContext = context
    }
    
    var userProfile: UserProfile?
    
    var fetchJobs : (() -> ()) = { }
    var fetchProfRole : (() -> ()) = { }
    
    private var jobs: [Job] = []
    private var profRole: String = String()
    
    var jobsList: [Job]? {
        didSet {
            fetchJobs()
        }
    }
    
    var profesionalRole: String? {
        didSet {
            fetchProfRole()
        }
    }
    
    func getJobPosts() {
        if let userEmail = getUserLocal() {
            getUserProfile(userEmail)
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
    
    func getUserProfile(_ email: String) {
        db.collection("users").document(email).getDocument(as: UserProfile.self) { result in
                switch result {
                    case .success(let userProfile):
                        self.userProfile = userProfile
                        self.profesionalRole = userProfile.profRole
                        self.getAllJobs()
                    case .failure(let error):
                        print("Error decoding user profile: \(error)")
                    }
                
            }
    }
    
    func getAllJobs() {
        db.collection("jobs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Deserializando...")
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        do {
                            var job = try document.data(as: Job.self)
                            job.id = document.documentID
                            self.jobs.append(job)
                        } catch {
                            print("Error en la conversión: \(error)")
                        }
                    }
                    self.filterJobs()
                }
            }
            
        }
    }
    
    func filterJobs() {
        var jobsTemp: [Job] = []
        jobs.forEach { job in
            if job.job.contains(userProfile!.profRole) && !job.applicants.contains(userProfile!.email) {
                jobsTemp.append(job)
            }
        }
        jobsList = jobsTemp
    }
    
    
    var fetchJobsFiltered : (() -> ()) = { }
    
    var jobsListFiltered: [Job]? {
        didSet {
            fetchJobsFiltered()
        }
    }

    func filterJobsByFilter(_ filter: String) {
        var jobsTemp: [Job] = []
        let filters = filter.split(separator: " ")
        jobs.forEach { job in
            filters.forEach{ filter in
                if job.job.contains(filter) {
                    jobsTemp.append(job)
                }
            }
        }
        jobsListFiltered = jobsTemp
    }
}
