//
//  ApplyJobViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 04/02/23.
//

import UIKit
import Lottie
import MessageUI

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
    private let appdel = UIApplication.shared.delegate as! AppDelegate
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
    
    @IBAction func contactRecruiter(_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlert("El dispositivo no puede enviar emails")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([jobSelected!.emailRecruiter])
        composer.setSubject("Contacto \(jobSelected!.job)")
        present(composer, animated: true)
    }
    
    @IBAction func applyJob(_ sender: Any) {
        activityProgress.isHidden = false
        activityProgress.startAnimating()
        if appdel.internetStatus {
            applyJobViewModel!.applyJob(job: self.jobSelected!)
            bind()
        } else {
            showNoInternet()
        }
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

extension ApplyJobViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        switch result{
        case .cancelled:
            print("Email cancelado")
        case .failed:
            print("Error al enviar")
        case .saved:
            print("Guardado")
            navigationController?.dismiss(animated: true)
        case .sent:
            print("Email enviado")
            navigationController?.dismiss(animated: true)
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true)
    }
}

extension ApplyJobViewController {
    func showNoInternet() {
        let alertController = UIAlertController(title: "Ops!",
                                                message: "Lo sentimos, al parecer no hay conexión a internet. Para seguir utilizando la App se requiere una conexión",
                                                preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Enterado", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
