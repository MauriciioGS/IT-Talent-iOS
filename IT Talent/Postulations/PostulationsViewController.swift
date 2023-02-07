//
//  PostulationsViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 06/02/23.
//

import UIKit
import Lottie

class PostulationsViewController: UIViewController {
    
    @IBOutlet weak var header1Label: UILabel!
    @IBOutlet weak var header2Label: UILabel!
    @IBOutlet weak var actContainerView: UIView!
    @IBOutlet weak var pastContainerView: UIView!
    @IBOutlet weak var activesCollectionView: UICollectionView!
    @IBOutlet weak var pastCollectionView: UICollectionView!
    
    private var loadingAnim: LottieAnimationView?
    private var loadingAnim2: LottieAnimationView?
    private var noDataAnim: LottieAnimationView?
    private var noDataAnim2: LottieAnimationView?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let appdel = UIApplication.shared.delegate as! AppDelegate
    private var postulViewModel: PostulationsViewModel?
    
    private var activePostulations: [Job] = []
    private var pastPostulations: [Job] = []
    private var jobSelected: Job?
    
    private var activeCellWidth: CGFloat?
    private var pastCellWidth: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()

        postulViewModel = PostulationsViewModel(context)
        setAnims()
        setCollectionViews()
        
        if appdel.internetStatus {
            postulViewModel!.getMyActivePostul()
            bindActives()
        } else {
            showNoInternet()
        }
    }
    
    private func setAnims() {
        noDataAnim = .init(name: "no_data")
        noDataAnim!.frame = actContainerView.bounds
        noDataAnim!.contentMode = .scaleAspectFit
        noDataAnim!.loopMode = .loop
        noDataAnim!.animationSpeed = 0.5
        actContainerView.addSubview(noDataAnim!)
        noDataAnim!.play()
        noDataAnim!.isHidden = true
        
        loadingAnim = .init(name: "loading_anim")
        loadingAnim!.frame = actContainerView.bounds
        loadingAnim!.contentMode = .scaleAspectFit
        loadingAnim!.loopMode = .loop
        loadingAnim!.animationSpeed = 0.5
        actContainerView.addSubview(loadingAnim!)
        loadingAnim!.play()
        
        noDataAnim2 = .init(name: "no_data")
        noDataAnim2!.frame = pastContainerView.bounds
        noDataAnim2!.contentMode = .scaleAspectFit
        noDataAnim2!.loopMode = .loop
        noDataAnim2!.animationSpeed = 0.5
        pastContainerView.addSubview(noDataAnim2!)
        noDataAnim2!.play()
        noDataAnim2!.isHidden = true
        
        loadingAnim2 = .init(name: "loading_anim")
        loadingAnim2!.frame = pastContainerView.bounds
        loadingAnim2!.contentMode = .scaleAspectFit
        loadingAnim2!.loopMode = .loop
        loadingAnim2!.animationSpeed = 0.5
        pastContainerView.addSubview(loadingAnim2!)
        loadingAnim2!.play()
    }

    private func setCollectionViews() {
        activesCollectionView.register(UINib(nibName: "JobProcessViewCell", bundle: nil), forCellWithReuseIdentifier: "jobProcessCell")
        activeCellWidth = activesCollectionView.bounds.width - (activesCollectionView.bounds.width / 8)
        
        activesCollectionView.delegate = self
        activesCollectionView.dataSource = self
        activesCollectionView.isHidden = true
        
        pastCollectionView.register(UINib(nibName: "JobProcessViewCell", bundle: nil), forCellWithReuseIdentifier: "jobProcessCell")
        pastCellWidth = pastCollectionView.bounds.width - (pastCollectionView.bounds.width / 4)
        
        pastCollectionView.isHidden = true
        pastCollectionView.delegate = self
        pastCollectionView.dataSource = self
    }
    
    private func bindActives() {
        postulViewModel!.fetchActivePostul = {
            DispatchQueue.main.async {
                if let postulActives = self.postulViewModel!.activePostul {
                    if postulActives.isEmpty {
                        self.loadingAnim!.isHidden = true
                        self.noDataAnim!.isHidden = false
                    } else {
                        self.loadingAnim!.isHidden = true
                        self.noDataAnim!.isHidden = true
                        self.activesCollectionView.isHidden = false
                        self.activesCollectionView.reloadData()
                        self.activePostulations = postulActives
                    }
                }
                
                if let postulPast = self.postulViewModel!.pastPostul {
                    if postulPast.isEmpty {
                        self.loadingAnim2!.isHidden = true
                        self.noDataAnim2!.isHidden = false
                    } else {
                        self.loadingAnim2!.isHidden = true
                        self.noDataAnim2!.isHidden = true
                        self.pastCollectionView.isHidden = false
                        self.pastCollectionView.reloadData()
                        self.pastPostulations = postulPast
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? StatusPostulViewController {
            destino.job = jobSelected
        }
    }

}

extension PostulationsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == activesCollectionView {
            return activePostulations.count
        }else {
            return pastPostulations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == activesCollectionView {
            let cell = activesCollectionView.dequeueReusableCell(withReuseIdentifier: "jobProcessCell", for: indexPath) as? JobProcessViewCell
            let job = activePostulations[indexPath.row]
            
            cell!.jobNameLabel.text = job.job
            cell!.enterpriseLabel.text = job.enterprise
            cell!.locationLabel.text = "| \(job.location)"
            cell!.typeLabel.text = "| \(job.type)"
            cell!.modeLabel.text = job.mode
            cell!.timeLabel.text = Date().getRelativeTimeAbbreviated(date: job.date, time: job.time)
            switch job.status {
            case 0:
                cell!.statusLabel.text = "Revisión de perfil"
            case 1:
                cell!.statusLabel.text = "Etapa de entrevistas"
                cell!.statusLabel.textColor = UIColor(named: "Warning")
            case 2:
                cell!.statusLabel.text = "Pruebas y evaluaciones"
                cell!.statusLabel.textColor = UIColor(named: "Success")
            case 4:
                break
            default:
                break
            }
            return cell!
        } else {
            let cell = activesCollectionView.dequeueReusableCell(withReuseIdentifier: "jobProcessCell", for: indexPath) as? JobProcessViewCell
            let job = pastPostulations[indexPath.row]
            
            cell!.jobNameLabel.text = job.job
            cell!.enterpriseLabel.text = job.enterprise
            cell!.locationLabel.text = "| \(job.location)"
            cell!.typeLabel.text = "| \(job.type)"
            cell!.modeLabel.text = job.mode
            cell!.timeLabel.text = Date().getRelativeTimeAbbreviated(date: job.date, time: job.time)
            cell!.statusLabel.text = "Aceptado"
            cell!.statusIcon.image = UIImage(named: "Ok_ic")
            cell!.statusLabel.textColor = UIColor(named: "Success")
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == activesCollectionView {
            jobSelected = activePostulations[indexPath.row]
            performSegue(withIdentifier: "toStatusJob", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == activesCollectionView {
            return CGSize(width: activeCellWidth!, height: 150.0)
        } else {
            return CGSize(width: pastCellWidth!, height: 150.0)
        }
    }
    
}

extension PostulationsViewController {
    func showNoInternet() {
        let alertController = UIAlertController(title: "Ops!",
                                                message: "Lo sentimos, al parecer no hay conexión a internet. Para seguir utilizando la App se requiere una conexión",
                                                preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Enterado", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
