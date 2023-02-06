//
//  StatusPostulViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 06/02/23.
//

import UIKit
import MessageUI

class StatusPostulViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var wageLabel: UILabel!
    @IBOutlet weak var enterpriseLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var applicantsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var vacanciesLabel: UILabel!

    var job: Job?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
    }
    
    private func initUI() {
        
        cardView.layer.cornerRadius = 10
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.4
        cardView.layer.shadowOffset = CGSize(width: 4, height: 4)
        cardView.layer.shadowRadius = 8
        cardView.layer.masksToBounds = false
        
        
        jobNameLabel.text = job!.job
        vacanciesLabel.text = "\(job!.vacancies) Vacantes"
        wageLabel.text = job!.wage
        enterpriseLabel.text = job!.enterprise
        locationLabel.text = "| \(job!.location)"
        contactButton.setTitle("\(job!.nameRecruiter.split(separator: " ")[0]) \(job!.nameRecruiter.split(separator: " ")[1])", for: .normal)
        applicantsLabel.text = "\(job!.applicants.count-1) Solicitantes"
        switch job!.status {
        case 0:
            statusLabel.text = "Revisión de perfil"
        case 1:
            statusLabel.text = "En etapa de entrevistas"
        case 2:
            statusLabel.text = "En etapa de pruebas y evaluaciones"
        default:
            break
        }
        timeLabel.text = job!.time
    }

    @IBAction func contactRecruiter(_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlert("El dispositivo no puede enviar emails")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([job!.emailRecruiter])
        composer.setSubject("Contacto puesto: \(job!.job)")
        present(composer, animated: true)
    }
    
    func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}

extension StatusPostulViewController: MFMailComposeViewControllerDelegate {
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
