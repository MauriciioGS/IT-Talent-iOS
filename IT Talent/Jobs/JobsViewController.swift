//
//  JobsViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 29/01/23.
//

import UIKit

import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class JobsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator1: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator2: UIActivityIndicatorView!
    @IBOutlet weak var newJobButton: UIButton!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var jobsViewModel: JobsViewModel?
    
    private var jobsList: [Job] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsViewModel = JobsViewModel(self.context)
        
        self.activityIndicator1.isHidden = false
        self.activityIndicator2.isHidden = false
        activityIndicator1.startAnimating()
        activityIndicator2.startAnimating()

        jobsViewModel!.getMyJobPosts()
        bindJobs()
    }
    
    private func bindJobs() {
        self.jobsViewModel!.fetchJobs = {
            DispatchQueue.main.async {
                if let jobs = self.jobsViewModel!.jobsList {
                    if jobs.isEmpty {
                        print("No jobs")
                        self.activityIndicator1.stopAnimating()
                        self.activityIndicator2.stopAnimating()
                        self.showAlertNoJobs("Todavía no tienes empleos publicados")
                    } else {
                        self.activityIndicator1.stopAnimating()
                        self.activityIndicator1.isHidden = true
                        self.activityIndicator2.stopAnimating()
                        self.activityIndicator2.isHidden = true
                        self.jobsList = jobs
                        print(self.jobsList)
                    }
                } else {
                    self.showAlert("Ocurrió un error inesperado")
                }
            }
        }
    }
    
    func showAlertNoJobs(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "Reintentar", style: UIAlertAction.Style.default, handler: { action in
            self.jobsViewModel!.getMyJobPosts()
        }))
        alert.addAction(UIAlertAction(title: "Crear empleo", style: UIAlertAction.Style.default, handler: { action in
            self.performSegue(withIdentifier: "toNewJob", sender: self)
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func newJob(_ sender: Any) {
        performSegue(withIdentifier: "toNewJob", sender: self)
    }

}
