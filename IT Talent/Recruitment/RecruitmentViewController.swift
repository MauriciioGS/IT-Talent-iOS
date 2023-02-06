//
//  RecruitmentViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 05/02/23.
//

import UIKit
import Lottie

class RecruitmentViewController: UIViewController {
    
    @IBOutlet weak var stage2CollectionView: UICollectionView!
    @IBOutlet weak var stage3CollectionView: UICollectionView!
    @IBOutlet weak var stage1CollectionView: UICollectionView!
    @IBOutlet weak var stage4CollectionView: UICollectionView!
    
    @IBOutlet weak var stage1ContainerView: UIView!
    @IBOutlet weak var stage2ContainerView: UIView!
    @IBOutlet weak var stage3ContainerView: UIView!
    @IBOutlet weak var stage4ContainerView: UIView!
    
    private var noDataAnim1: LottieAnimationView?
    private var noDataAnim2: LottieAnimationView?
    private var noDataAnim3: LottieAnimationView?
    private var noDataAnim4: LottieAnimationView?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var recruitmentViewModel: RecruitmentViewModel?
    
    private var jobs1CellWidth = CGFloat(0)
    private var jobs2CellWidth = CGFloat(0)
    private var jobs3CellWidth = CGFloat(0)
    private var jobs4CellWidth = CGFloat(0)
    
    private var jobsStage1: [Job] = []
    private var jobsStage2: [Job] = []
    private var jobsStage3: [Job] = []
    private var jobsStage4: [Job] = []
    
    private var jobSelected: Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recruitmentViewModel = RecruitmentViewModel(context)
        recruitmentViewModel!.getAllJobs()
        bindJobs()

        
        setCollectionViews()
        setAnims()
    }
    
    private func setCollectionViews() {
        
        stage1CollectionView.delegate = self
        stage2CollectionView.delegate = self
        stage3CollectionView.delegate = self
        stage4CollectionView.delegate = self
        
        stage1CollectionView.dataSource = self
        stage2CollectionView.dataSource = self
        stage3CollectionView.dataSource = self
        stage4CollectionView.dataSource = self
        
        stage1CollectionView.register(UINib(nibName: "JobRecruitmentViewCell", bundle: nil), forCellWithReuseIdentifier: "jobRecCell")
        jobs1CellWidth = stage1CollectionView.bounds.width - (stage1CollectionView.bounds.width / 4)
        
        stage2CollectionView.register(UINib(nibName: "JobRecruitmentViewCell", bundle: nil), forCellWithReuseIdentifier: "jobRecCell")
        jobs2CellWidth = stage2CollectionView.bounds.width - (stage2CollectionView.bounds.width / 4)
        stage3CollectionView.register(UINib(nibName: "JobRecruitmentViewCell", bundle: nil), forCellWithReuseIdentifier: "jobRecCell")
        jobs3CellWidth = stage3CollectionView.bounds.width - (stage3CollectionView.bounds.width / 4)
        stage4CollectionView.register(UINib(nibName: "JobRecruitmentViewCell", bundle: nil), forCellWithReuseIdentifier: "jobRecCell")
        jobs4CellWidth = stage4CollectionView.bounds.width - (stage4CollectionView.bounds.width / 4)
        
        stage1CollectionView.isHidden = true
        stage2CollectionView.isHidden = true
        stage3CollectionView.isHidden = true
        stage4CollectionView.isHidden = true
    }
    
    private func setAnims() {
        noDataAnim1 = .init(name: "no_data")
        noDataAnim1!.frame = stage1ContainerView.bounds
        noDataAnim1!.contentMode = .scaleAspectFit
        noDataAnim1!.loopMode = .loop
        noDataAnim1!.animationSpeed = 0.5
        stage1ContainerView.addSubview(noDataAnim1!)
        noDataAnim1!.play()
        
        noDataAnim2 = .init(name: "no_data")
        noDataAnim2!.frame = stage1ContainerView.bounds
        noDataAnim2!.contentMode = .scaleAspectFit
        noDataAnim2!.loopMode = .loop
        noDataAnim2!.animationSpeed = 0.5
        stage2ContainerView.addSubview(noDataAnim2!)
        noDataAnim2!.play()
        
        noDataAnim3 = .init(name: "no_data")
        noDataAnim3!.frame = stage1ContainerView.bounds
        noDataAnim3!.contentMode = .scaleAspectFit
        noDataAnim3!.loopMode = .loop
        noDataAnim3!.animationSpeed = 0.5
        stage3ContainerView.addSubview(noDataAnim3!)
        noDataAnim3!.play()
        
        noDataAnim4 = .init(name: "no_data")
        noDataAnim4!.frame = stage1ContainerView.bounds
        noDataAnim4!.contentMode = .scaleAspectFit
        noDataAnim4!.loopMode = .loop
        noDataAnim4!.animationSpeed = 0.5
        stage4ContainerView.addSubview(noDataAnim4!)
        noDataAnim4!.play()
    }
    
    private func bindJobs() {
        recruitmentViewModel!.fetchJobs = {
            DispatchQueue.main.async {
                if let areJobsLoaded = self.recruitmentViewModel!.areJobsLoaded {
                    if areJobsLoaded {
                        self.recruitmentViewModel!.getJobsStage1()
                        self.bindJobsStage1()
                        self.recruitmentViewModel!.getJobsStage2()
                        self.bindJobsStage2()
                        self.recruitmentViewModel!.getJobsStage3()
                        self.bindJobsStage3()
                        self.recruitmentViewModel!.getJobsStage4()
                        self.bindJobsStage4()
                    } else {
                        print("Ocurrió un error al obtener todos los jobs")
                    }
                }
            }
        }
    }
    
    private func bindJobsStage1() {
        recruitmentViewModel!.fetchStage1Jobs = {
            DispatchQueue.main.async {
                if let jobs = self.recruitmentViewModel!.jobsStage1 {
                    if jobs.isEmpty {
                        print("No hay jobs status 0")
                    } else {
                        print("Jobs Stage 1 obtenidos")
                        self.jobsStage1 = jobs
                        self.stage1CollectionView.reloadData()
                        self.stage1CollectionView.isHidden = false
                        self.noDataAnim1!.isHidden = true
                    }
                } else {
                    print("Error")
                }
            }
        }
    }
    
    private func bindJobsStage2() {
        recruitmentViewModel!.fetchStage2Jobs = {
            DispatchQueue.main.async {
                if let jobs = self.recruitmentViewModel!.jobsStage2 {
                    if jobs.isEmpty {
                        print("No hay jobs status 1")
                    } else {
                        print("Jobs Stage 2 obtenidos")
                        self.jobsStage2 = jobs
                        self.stage2CollectionView.reloadData()
                        self.stage2CollectionView.isHidden = false
                        self.noDataAnim2!.isHidden = true
                    }
                } else {
                    print("Error")
                }
            }
        }
    }
    
    private func bindJobsStage3() {
        recruitmentViewModel!.fetchStage3Jobs = {
            DispatchQueue.main.async {
                if let jobs = self.recruitmentViewModel!.jobsStage3 {
                    if jobs.isEmpty {
                        print("No hay jobs status 2")
                    } else {
                        print("Jobs Stage 3 obtenidos")
                        self.jobsStage3 = jobs
                        self.stage3CollectionView.reloadData()
                        self.stage3CollectionView.isHidden = false
                        self.noDataAnim3!.isHidden = true
                    }
                } else {
                    print("Error")
                }
            }
        }
    }
    
    private func bindJobsStage4() {
        recruitmentViewModel!.fetchStage4Jobs = {
            DispatchQueue.main.async {
                if let jobs = self.recruitmentViewModel!.jobsStage4 {
                    if jobs.isEmpty {
                        print("No hay jobs status 2")
                    } else {
                        print("Jobs Stage 3 obtenidos")
                        self.jobsStage4 = jobs
                        self.stage4CollectionView.reloadData()
                        self.stage4CollectionView.isHidden = false
                        self.noDataAnim4!.isHidden = true
                    }
                } else {
                    print("Error")
                }
            }
        }
    }
    
    func showAlert(_ titleAlert: String, _ messageAlert: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? SelectApplicantsViewController {
            destino.jobSelected = jobSelected!
        }
    }
}

extension RecruitmentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case stage1CollectionView:
            return jobsStage1.count
        case stage2CollectionView:
            return jobsStage2.count
        case stage3CollectionView:
            return jobsStage3.count
        case stage4CollectionView:
            return jobsStage4.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let jobCell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobRecCell", for: indexPath) as? JobRecruitmentViewCell
        
        switch collectionView {
        case stage1CollectionView:
            let job = jobsStage1[indexPath.row]
            jobCell!.jobNameLabel.text = job.job
            jobCell!.enterpriseLabel.text = job.enterprise
            jobCell!.publisherLabel.text = "Publicado por: \(job.nameRecruiter.split(separator: " ")[0]) \(job.nameRecruiter.split(separator: " ")[1])"
            jobCell!.applicantsLabel.text = "\(job.applicants.count-1) Solicitantes"
            jobCell!.vacanciesLabel.text = "\(job.vacancies) Vacantes"
            jobCell!.rejectedLabel.isHidden = true
            jobCell!.timeLabel.text = job.time
            return jobCell!
        case stage2CollectionView:
            let job = jobsStage2[indexPath.row]
            jobCell!.jobNameLabel.text = job.job
            jobCell!.enterpriseLabel.text = job.enterprise
            jobCell!.publisherLabel.text = "Publicado por: \(job.nameRecruiter.split(separator: " ")[0]) \(job.nameRecruiter.split(separator: " ")[1])"
            jobCell!.applicantsLabel.text = "\(job.applicants.count-1) Solicitantes"
            jobCell!.vacanciesLabel.text = "\(job.vacancies) Vacantes"
            jobCell!.rejectedLabel.isHidden = true
            jobCell!.timeLabel.text = job.time
            jobCell!.actionButton.setTitle("Ver Solicitantes", for: .normal)
            return jobCell!
        case stage3CollectionView:
            let job = jobsStage3[indexPath.row]
            jobCell!.jobNameLabel.text = job.job
            jobCell!.enterpriseLabel.text = job.enterprise
            jobCell!.publisherLabel.text = "Publicado por: \(job.nameRecruiter.split(separator: " ")[0]) \(job.nameRecruiter.split(separator: " ")[1])"
            jobCell!.applicantsLabel.text = "\(job.applicants.count-1) Solicitantes"
            jobCell!.vacanciesLabel.text = "\(job.vacancies) Vacantes"
            jobCell!.rejectedLabel.text = "0 rechazados"
            jobCell!.timeLabel.text = job.time
            jobCell!.actionButton.setTitle("Ver Solicitantes", for: .normal)
            return jobCell!
        case stage4CollectionView:
            let job = jobsStage4[indexPath.row]
            jobCell!.jobNameLabel.text = job.job
            jobCell!.enterpriseLabel.text = job.enterprise
            jobCell!.publisherLabel.text = "Publicado por: \(job.nameRecruiter.split(separator: " ")[0]) \(job.nameRecruiter.split(separator: " ")[1])"
            jobCell!.applicantsLabel.isHidden = true
            jobCell!.vacanciesLabel.text = "\(job.applicants.count-1) Aceptados"
            jobCell!.rejectedLabel.isHidden = true
            jobCell!.timeLabel.text = job.time
            jobCell!.actionButton.isHidden = true
            return jobCell!
        default:
            return jobCell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case stage1CollectionView:
            // create the alert
            let alert = UIAlertController(title: "Siguiente etapa: Entrevistas", message: "La siguiente etapa consiste en revisar los perfiles profesionales (CV) de los candidatos al puesto de Cargo.\nAl pasar a la segunda etapa se retirara el anuncio de empleo, por lo tanto no le aparecerá a nuevos aspirantes.\n¿Deseas pasar a la segunda etapa: Revisión de perfiles?", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.default, handler: { action in
                
            }))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        case stage2CollectionView:
            jobSelected = jobsStage2[indexPath.row]
            performSegue(withIdentifier: "toApplicants", sender: self)
        case stage3CollectionView:
            jobSelected = jobsStage3[indexPath.row]
            performSegue(withIdentifier: "toApplicants", sender: self)
        case stage4CollectionView:
            return
        default:
            return
        }
    }
    
}

extension RecruitmentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case stage1CollectionView:
            return CGSizeMake(jobs1CellWidth, 202.0)
        case stage2CollectionView:
            return CGSizeMake(jobs2CellWidth, 202.0)
        case stage3CollectionView:
            return CGSizeMake(jobs3CellWidth, 202.0)
        case stage4CollectionView:
            return CGSizeMake(jobs4CellWidth, 202.0)
        default:
            return CGSizeMake(jobs1CellWidth, 202.0)
        }
        
    }
}
