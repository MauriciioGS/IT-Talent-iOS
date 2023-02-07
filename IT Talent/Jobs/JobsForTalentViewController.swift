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
    private var noDataAnim: LottieAnimationView?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let appdel = UIApplication.shared.delegate as! AppDelegate
    
    private var jobsViewModel: JobsTalentViewModel?
    
    private var jobsList: [Job] = []
    private var jobSelected: Job?
    private var profRol: String?
    private var cellJobWidth: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Date())

        if appdel.internetStatus {
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
            
            noDataAnim = .init(name: "no_data")
            noDataAnim!.frame = animContainerView.bounds
            noDataAnim!.contentMode = .scaleAspectFit
            noDataAnim!.loopMode = .loop
            noDataAnim!.animationSpeed = 0.5
            
            animContainerView.isHidden = false
            loadingAnim!.isHidden = false
            noDataAnim!.isHidden = true
            
            jobsCollectionView.register(UINib(nibName: "JobsTalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "jobTalCell")
            
            cellJobWidth = jobsCollectionView.bounds.width - (jobsCollectionView.bounds.width / 6)
            filterPicker.delegate = self
            filterPicker.dataSource = self
            
            jobsCollectionView.delegate = self
            jobsCollectionView.dataSource = self
            
            bindJobs()
            bindProfRole()
        } else {
            showNoInternet()
        }
    }
    
    func bindJobs() {
        self.jobsViewModel!.fetchJobs = {
            DispatchQueue.main.async {
                if let jobs = self.jobsViewModel!.jobsList {
                    if jobs.isEmpty {
                        self.loadingAnim!.isHidden = true
                        self.noDataAnim!.isHidden = false
                        self.animContainerView.addSubview(self.noDataAnim!)
                        self.noDataAnim!.play()
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
                        self.loadingAnim!.isHidden = true
                        self.noDataAnim!.isHidden = false
                        self.animContainerView.addSubview(self.noDataAnim!)
                        self.noDataAnim!.play()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? ApplyJobViewController {
            destino.jobSelected = self.jobSelected
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
        jobCell!.applicantsLabel.text = "| \(job.applicants.count-1) Solicitantes"
        jobCell!.wageLabel.text = job.wage
        jobCell!.timeLabel.text = Date().getRelativeTimeAbbreviated(date: job.date, time: job.time)
        return jobCell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        jobSelected = jobsList[indexPath.row]
        performSegue(withIdentifier: "goToApply", sender: self)
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
        
        loadingAnim!.isHidden = false
        noDataAnim!.isHidden = true

        if appdel.internetStatus {
            jobsViewModel!.filterJobsByFilter(profRol!)
            jobsList.removeAll()
            bindFiltered()
            headerLabel.text = "Empleos \(profRol!)"
        } else {
            showNoInternet()
        }
    }
}

extension JobsForTalentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellJobWidth!, height: 142)
    }
}

extension JobsForTalentViewController {
    func showNoInternet() {
        let alertController = UIAlertController(title: "Ops!",
                                                message: "Lo sentimos, al parecer no hay conexión a internet. Para seguir utilizando la App se requiere una conexión",
                                                preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Enterado", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
