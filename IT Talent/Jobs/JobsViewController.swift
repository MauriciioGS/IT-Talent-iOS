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
import Lottie

class JobsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator1: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator2: UIActivityIndicatorView!
    @IBOutlet weak var newJobButton: UIButton!
    @IBOutlet weak var collectionViewActive: UICollectionView!
    @IBOutlet weak var collectionViewPast: UICollectionView!
    @IBOutlet weak var refreshDataButton: UIButton!
    
    
    private var noDataAnimation: LottieAnimationView?
    private var noDataAnimation2: LottieAnimationView?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var jobsViewModel: JobsViewModel?
    
    private var jobsListActive: [Job] = []
    private var jobsListPast: [Job] = []
    
    private var cellJobActiveWidth: CGFloat?// debe ser comparando con el Tamaño del stack
    private var cellJobPastWidth: CGFloat?
    //UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellJobActiveWidth = collectionViewActive.bounds.width - (collectionViewActive.bounds.width / 6)
        
        cellJobPastWidth = collectionViewPast.bounds.width - (collectionViewPast.bounds.width / 4)
        
        jobsViewModel = JobsViewModel(self.context)
        
        collectionViewActive.dataSource = self
        collectionViewActive.delegate = self
        collectionViewActive.register(UINib(nibName: "JobViewCell", bundle: nil), forCellWithReuseIdentifier: "jobPostedCell")
        collectionViewPast.dataSource = self
        collectionViewPast.delegate = self
        collectionViewPast.register(UINib(nibName: "JobPastViewCell", bundle: nil), forCellWithReuseIdentifier: "jobPastCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                        self.activityIndicator1.stopAnimating()
                        self.activityIndicator1.isHidden = true
                        self.activityIndicator2.stopAnimating()
                        self.activityIndicator2.isHidden = true
                        self.showAlertNoJobs("Todavía no tienes empleos publicados")
                    } else {
                        self.activityIndicator1.stopAnimating()
                        self.activityIndicator1.isHidden = true
                        self.activityIndicator2.stopAnimating()
                        self.activityIndicator2.isHidden = true
                        
                        self.getJobs(jobs)
                    }
                } else {
                    self.showAlert("Ocurrió un error inesperado")
                }
            }
        }
    }
    
    private func getJobs(_ jobs: [Job]) {
        jobsListActive.removeAll()
        jobsListPast.removeAll()
        jobs.forEach { job in
            if job.status != 4 {
                jobsListActive.append(job)
            } else {
                jobsListPast.append(job)
            }
        }
        collectionViewActive.reloadData()
        collectionViewPast.reloadData()
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
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

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
    
    @IBAction func refreshData(_ sender: Any) {
        jobsViewModel!.getMyJobPosts()
    }
    

}

// MARK: - UICollectionViewDataSource
extension JobsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewActive {
            return jobsListActive.count
        } else {
            return jobsListPast.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewActive {
            let jobCell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobPostedCell", for: indexPath) as? JobViewCell
            
            let job = jobsListActive[indexPath.row]
            jobCell!.chargeLabel.text = job.job
            jobCell!.enterpriseLabel.text = job.enterprise
            jobCell!.publisherLabel.text = "Publicado por: \(job.nameRecruiter.split(separator: " ")[0])"
            jobCell!.vacanciesLabel.text = "\(job.vacancies) Vacantes"
            jobCell!.applicantsLabel.text = "| \(job.applicants.count) Solicitantes"
            jobCell!.timeLabel.text = job.time
            return jobCell!
        } else {
            let jobCell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobPastCell", for: indexPath) as? JobPastViewCell
            
            let job = jobsListPast[indexPath.row]
            jobCell!.chargeLabel.text = job.job
            jobCell!.enterpriseLabel.text = job.enterprise
            jobCell!.publisherLabel.text = "Publicado por: \(job.nameRecruiter.split(separator: " ")[0])"
            jobCell!.vacanciesLabel.text = "\(job.vacancies) Vacantes"
            jobCell!.applicantsLabel.text = "\(job.applicants.count) Solicitantes"
            if (job.applicants.count - (Int(job.vacancies) ?? 0)) < 0 {
                jobCell?.rejectedLabel.text = "0 Rechazados"
            } else {
                jobCell?.rejectedLabel.text = "\(job.applicants.count - (Int(job.vacancies) ?? 0)) Rechazados"
            }
            jobCell!.timeLabel.text = job.time
            return jobCell!
        }
    }
    
}

extension JobsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewActive {
            return CGSize(width: cellJobActiveWidth!, height: 140)
        }
        if collectionView == collectionViewPast {
            return CGSize(width: cellJobPastWidth!, height: 154)
        }
        return CGSize(width: 0,height: 0)
    }
}
