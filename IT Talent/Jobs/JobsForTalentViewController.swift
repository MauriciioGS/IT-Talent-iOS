//
//  JobsForTalentViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 03/02/23.
//

import UIKit
import Lottie

class JobsForTalentViewController: UIViewController {
    
    @IBOutlet weak var containerFilters: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var jobsCollectionView: UICollectionView!
    @IBOutlet weak var animContainerView: UIView!
    
    @IBOutlet weak var filterPicker: UIPickerView!
    
    private var loadingAnim: LottieAnimationView?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var jobsViewModel: JobsTalentViewModel?
    
    private var jobsList: [Job] = []
    private var profRol: String?
    private var cellJobWidth: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()

        jobsViewModel = JobsTalentViewModel(context)
        jobsViewModel!.getJobPosts()
        
        containerFilters.layer.cornerRadius = 10
        containerFilters.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        loadingAnim = .init(name: "loading_anim")
        loadingAnim!.frame = animContainerView.bounds
        loadingAnim!.contentMode = .scaleAspectFit
        loadingAnim!.loopMode = .loop
        loadingAnim!.animationSpeed = 0.5
        animContainerView.addSubview(loadingAnim!)
        loadingAnim!.play()
        
        animContainerView.isHidden = false
        
        jobsCollectionView.register(UINib(nibName: "JobsTalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "jobTalCell")
        
        cellJobWidth = jobsCollectionView.bounds.width - (jobsCollectionView.bounds.width / 6)
        filterPicker.delegate = self
        filterPicker.dataSource = self
        
        jobsCollectionView.delegate = self
        jobsCollectionView.dataSource = self
        
        bindJobs()
        bindProfRole()
        
    }
    
    func bindJobs() {
        self.jobsViewModel!.fetchJobs = {
            DispatchQueue.main.async {
                if let jobs = self.jobsViewModel!.jobsList {
                    if jobs.isEmpty {
                        print("Lista vacía")
                    } else {
                        self.animContainerView.isHidden = true
                        self.jobsCollectionView.isHidden = false
                        self.jobsList = jobs
                        self.jobsCollectionView.reloadData()
                    }
                } else {
                    print("Ocurrió un error inesperado")
                }
            }
        }
    }
    
    private func bindProfRole() {
        self.jobsViewModel!.fetchProfRole = {
            DispatchQueue.main.async {
                if let userProfRole = self.jobsViewModel!.profesionalRole {
                    self.profRol = userProfRole
                    self.headerLabel.text = "Empleos \(userProfRole)"
                    if let indexFilter = ProfRoles.arrayProfRoles.firstIndex(of: userProfRole){
                        self.filterPicker.selectRow(indexFilter, inComponent: 0, animated: true)
                    }
                } else {
                    print("Ocurrió un error inesperado")
                }
            }
        }
    }
    
    private func bindFiltered() {
        self.jobsViewModel!.fetchJobsFiltered = {
            DispatchQueue.main.async {
                if let jobs = self.jobsViewModel!.jobsListFiltered {
                    if jobs.isEmpty {
                        print("Lista vacía")
                        // Dtener loader y colocar no data
                    } else {
                        self.animContainerView.isHidden = true
                        self.jobsCollectionView.isHidden = false
                        self.jobsList = jobs
                        self.jobsCollectionView.reloadData()
                    }
                } else {
                    print("Ocurrió un error inesperado")
                }
            }
        }
    }

    

}

extension JobsForTalentViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let jobCell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobTalCell", for: indexPath) as? JobsTalCollectionViewCell
        let job = jobsList[indexPath.row]
        jobCell!.jobLabel.text = job.job
        jobCell!.enterpriseLabel.text = job.enterprise
        jobCell!.countryLabel.text = job.location
        jobCell!.modeLabel.text = job.mode
        jobCell!.typeLabel.text = job.type
        jobCell!.vacanciesLabel.text = "\(job.vacancies) Vacantes"
        jobCell!.applicantsLabel.text = "| \(job.applicants.count) Solicitantes"
        jobCell!.wageLabel.text = job.wage
        jobCell!.timeLabel.text = job.time
        return jobCell!
    }


}

extension JobsForTalentViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ProfRoles.arrayProfRoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ProfRoles.arrayProfRoles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        animContainerView.isHidden = false
        jobsCollectionView.isHidden = true
        profRol = ProfRoles.arrayProfRoles[row]
        jobsViewModel!.filterJobsByFilter(profRol!)
        jobsList.removeAll()
        bindFiltered()
        headerLabel.text = "Empleos \(profRol!)"
    }
}

extension JobsForTalentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellJobWidth!, height: 142)
    }
}
