//
//  ApplyJobViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 04/02/23.
//

import UIKit
import Lottie

class ApplyJobViewController: UIViewController {
    
    @IBOutlet weak var enterpriseImage: UIImageView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var vacanciesLabel: UILabel!
    @IBOutlet weak var wageLabel: UILabel!
    @IBOutlet weak var enterpriseLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var recruiterLabel: UILabel!
    @IBOutlet weak var recruiterButton: UIButton!
    @IBOutlet weak var modalLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var applicantsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var carContainerView: UIView!
    @IBOutlet weak var activityProgress: UIActivityIndicatorView!
    
    @IBOutlet weak var succesContainerView: UIView!
    @IBOutlet weak var headerSuccess: UILabel!
    @IBOutlet weak var succesAnimView: UIView!
    
    private var successAnim: LottieAnimationView?
    var jobSelected: Job?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var applyJobViewModel: ApplyJobViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyJobViewModel = ApplyJobViewModel(context)
        
        succesContainerView.isHidden = true
        carContainerView.isHidden = false
        activityProgress.isHidden = true
        
        carContainerView.layer.cornerRadius = 10
        carContainerView.layer.shadowColor = UIColor.black.cgColor
        carContainerView.layer.shadowOpacity = 0.2
        carContainerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        carContainerView.layer.shadowRadius = 5
        carContainerView.layer.masksToBounds = false

        jobNameLabel.text = jobSelected!.job
        vacanciesLabel.text = "\(jobSelected!.vacancies) Vacantes"
        enterpriseLabel.text = jobSelected!.enterprise
        wageLabel.text = jobSelected!.wage
        cityLabel.text = jobSelected!.location
        recruiterButton.setTitle(jobSelected!.nameRecruiter, for: .normal)
        modalLabel.text = jobSelected!.mode
        typeLabel.text = "| \(jobSelected!.type)"
        applicantsLabel.text = "\(jobSelected!.applicants.count-1) Solicitantes"
        timeLabel.text = jobSelected!.time
        
        successAnim = .init(name: "mail_send")
        successAnim!.frame = succesAnimView.bounds
        successAnim!.contentMode = .scaleAspectFit
        successAnim!.loopMode = .loop
        successAnim!.animationSpeed = 0.5
        succesAnimView.addSubview(successAnim!)
        successAnim!.play()
        
    }

    
    @IBAction func applyJob(_ sender: Any) {
        activityProgress.isHidden = false
        activityProgress.startAnimating()
        applyJobViewModel!.applyJob(job: self.jobSelected!)
        bind()
    }
    
    private func bind() {
        applyJobViewModel!.applyJobUIStatus = {
            DispatchQueue.main.async {
                if let isApplied = self.applyJobViewModel!.isApplied {
                    if isApplied {
                        self.showSuccess()
                    } else {
                        self.showAlert("Ocurrió un error en tu solicitud, intenta de nuevo más tarde")
                    }
                }
            }
        }
    }
    
    private func showSuccess() {
        self.activityProgress.stopAnimating()
        self.activityProgress.isHidden = true
        self.succesContainerView.isHidden = false
        self.carContainerView.isHidden = true
        
        headerSuccess.text = "¡Te has postulado para \(jobSelected!.job)!"
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
