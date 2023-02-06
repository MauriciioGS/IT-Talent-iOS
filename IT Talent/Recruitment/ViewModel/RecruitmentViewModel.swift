//
//  RecruitmentViewModel.swift
//  IT Talent
//
//  Created by Mauricio García S on 05/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

private let PROCESS_JOB_STAGE1 = 0
private let PROCESS_JOB_STAGE2 = 1
private let PROCESS_JOB_STAGE3 = 2
private let PROCESS_JOB_FINISHED = 4

class RecruitmentViewModel {
    
    private var mObjectContext: NSManagedObjectContext?
    private let db = Firestore.firestore()
    
    init(_ context: NSManagedObjectContext? = nil) {
        self.mObjectContext = context
    }
    
    var fetchJobs : (() -> ()) = { }
    
    private var myJobs: [Job] = []
    
    var areJobsLoaded: Bool? {
        didSet {
            fetchJobs()
        }
    }
    
    func getAllJobs() {
        if let userEmail = getUserLocal() {
            getJobsByUser(email: userEmail)
        } else {
            print("Error al obtener el usuario localmente")
            self.areJobsLoaded = false
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
                self.areJobsLoaded = false
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
                            self.areJobsLoaded = false
                        }
                    }
                    self.areJobsLoaded = true
                }
            }
        }
    }
    
    var fetchStage1Jobs : (() -> ()) = { }
    
    private var jobsS1List: [Job] = []
    
    var jobsStage1: [Job]? {
        didSet {
            fetchStage1Jobs()
        }
    }
    
    func getJobsStage1() {
        jobsS1List.removeAll()
        DispatchQueue.main.async {
            if self.myJobs.isEmpty {
                self.jobsStage1 = self.jobsS1List
                print("No hay jobs para filtrar")
            } else {
                self.myJobs.forEach { job in
                    if job.status == PROCESS_JOB_STAGE1 {
                        self.jobsS1List.append(job)
                    }
                }
                self.jobsStage1 = self.jobsS1List
            }
        }
    }
    
    var fetchStage2Jobs : (() -> ()) = { }
    
    private var jobsS2List: [Job] = []
    
    var jobsStage2: [Job]? {
        didSet {
            fetchStage2Jobs()
        }
    }
    
    func getJobsStage2() {
        jobsS2List.removeAll()
        DispatchQueue.main.async {
            if self.myJobs.isEmpty {
                self.jobsStage2 = self.jobsS2List
                print("No hay jobs para filtrar")
            } else {
                self.myJobs.forEach { job in
                    if job.status == PROCESS_JOB_STAGE2 {
                        self.jobsS2List.append(job)
                    }
                }
                self.jobsStage2 = self.jobsS2List
            }
        }
    }
    
    var fetchStage3Jobs : (() -> ()) = { }
    
    private var jobsS3List: [Job] = []
    
    var jobsStage3: [Job]? {
        didSet {
            fetchStage3Jobs()
        }
    }
    
    func getJobsStage3() {
        jobsS3List.removeAll()
        DispatchQueue.main.async {
            if self.myJobs.isEmpty {
                self.jobsStage3 = self.jobsS3List
                print("No hay jobs para filtrar")
            } else {
                self.myJobs.forEach { job in
                    if job.status == PROCESS_JOB_STAGE3 {
                        self.jobsS3List.append(job)
                    }
                }
                self.jobsStage3 = self.jobsS3List
            }
        }
    }
    
    var fetchStage4Jobs : (() -> ()) = { }
    
    private var jobsS4List: [Job] = []
    
    var jobsStage4: [Job]? {
        didSet {
            fetchStage4Jobs()
        }
    }
    
    func getJobsStage4() {
        jobsS4List.removeAll()
        DispatchQueue.main.async {
            if self.myJobs.isEmpty {
                self.jobsStage4 = self.jobsS4List
                print("No hay jobs para filtrar")
            } else {
                self.myJobs.forEach { job in
                    if job.status == PROCESS_JOB_FINISHED {
                        self.jobsS4List.append(job)
                    }
                }
                self.jobsStage4 = self.jobsS4List
            }
        }
    }
    
    var fetchJobChangeStage : (() -> ()) = { }
    
    var showSuccess: Bool? {
        didSet {
            fetchJobChangeStage()
        }
    }
    
    func setNextStage(_ job: Job) {
        db.collection("jobs").document(job.id!).updateData([
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
