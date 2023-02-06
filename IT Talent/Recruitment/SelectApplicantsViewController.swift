//
//  SelectApplicantsViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 05/02/23.
//

import UIKit
import Lottie
import MessageUI

class SelectApplicantsViewController: UIViewController {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var applicantsCollectionView: UICollectionView!
    @IBOutlet weak var animContainerView: UIView!
    
    private var noDataAnim: LottieAnimationView?
    private var loadingAnim: LottieAnimationView?
    private let selectApplicantsViewModel = SelectApplicantsViewModel()
    private let appdel = UIApplication.shared.delegate as! AppDelegate
    private var cellWidth: CGFloat?
    
    var jobSelected: Job?
    var listOfApplicants: [UserProfile] = []
    var applicantsEmails: [String] = []
    var numApplicants: Int = Int()
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appdel.internetStatus {
            selectApplicantsViewModel.getAppplicantsByJob(jobSelected!.applicants)
            
            applicantsCollectionView.allowsMultipleSelection = true
            applicantsCollectionView.register(UINib(nibName: "ApplicantViewCell", bundle: nil), forCellWithReuseIdentifier: "applicantCell")
            applicantsCollectionView.dataSource = self
            applicantsCollectionView.delegate = self
            applicantsCollectionView.isHidden = true
            
            cellWidth = applicantsCollectionView.bounds.width - (applicantsCollectionView.bounds.width / 8)
            
            noDataAnim = .init(name: "no_data")
            noDataAnim!.frame = animContainerView.bounds
            noDataAnim!.contentMode = .scaleAspectFit
            noDataAnim!.loopMode = .loop
            noDataAnim!.animationSpeed = 0.5
            animContainerView.addSubview(noDataAnim!)
            noDataAnim!.play()
            noDataAnim!.isHidden = true
            
            loadingAnim = .init(name: "loading_anim")
            loadingAnim!.frame = animContainerView.bounds
            loadingAnim!.contentMode = .scaleAspectFit
            loadingAnim!.loopMode = .loop
            loadingAnim!.animationSpeed = 0.5
            animContainerView.addSubview(loadingAnim!)
            loadingAnim!.play()
            loadingAnim!.isHidden = false
            
            animContainerView.isHidden = false
            
            actionButton.setTitle("\(numApplicants) A la siguiente etapa", for: .normal)
            
            bind()
        } else {
            showNoInternet()
        }
    }
    
    private func bind() {
        selectApplicantsViewModel.fetchApplicants = {
            DispatchQueue.main.async {
                if let applicants = self.selectApplicantsViewModel.applicantsList {
                    if applicants.isEmpty {
                        self.noDataAnim!.isHidden = false
                        self.loadingAnim!.isHidden = true
                        print("Lista vacia")
                    } else {
                        self.listOfApplicants = applicants
                        self.loadingAnim!.isHidden = true
                        self.animContainerView.isHidden = true
                        self.applicantsCollectionView.isHidden = false
                        self.applicantsCollectionView.reloadData()
                    }
                } else {
                    print("Aqui")
                }
            }
        }
    }

    @IBAction func toNextStage(_ sender: Any) {
        if numApplicants != 0 {
            var deleteNeededIndexPaths: [IndexPath] = []
            for (key, value) in dictionarySelectedIndexPath {
                if value {
                    deleteNeededIndexPaths.append(key)
                }
            }
            
            for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
                applicantsEmails.append(listOfApplicants[i.row].email)
            }
        
            applicantsEmails.append("")
            jobSelected!.applicants = applicantsEmails
            if jobSelected!.status == 2 {
                jobSelected!.status = 4
            } else {
                jobSelected!.status += 1
            }
            if appdel.internetStatus {
                selectApplicantsViewModel.setNewStage(jobSelected!)
                bindNewStage()
            } else {
                showNoInternet()
            }
        } else {
            showAlert("Por favor, selecciona a los solicitantes que pasan a la siguiente etapa.")
        }
    }
    
    private func bindNewStage() {
        selectApplicantsViewModel.fetchNewApplicants = {
            DispatchQueue.main.async {
                if let _ = self.selectApplicantsViewModel.showSuccess {
                    if self.jobSelected!.status == 4 {
                        // create the alert
                        let alert = UIAlertController(title: "Dales la bienvenida!", message: "Informale a las personas que fueron aceptadas y dales una calurosa bienvenida.\n¡De nuestra parte, nos queda desearte la mejor de las experiencias con estos talentos!", preferredStyle: UIAlertController.Style.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Después", style: UIAlertAction.Style.default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Enviar Correo", style: UIAlertAction.Style.default, handler: { action in
                            guard MFMailComposeViewController.canSendMail() else {
                                self.showAlert("El dispositivo no puede enviar emails")
                                return
                            }
                            
                            let composer = MFMailComposeViewController()
                            composer.mailComposeDelegate = self
                            composer.setToRecipients(self.jobSelected!.applicants)
                            composer.setSubject("Contacto oportunidad laboral")
                            self.present(composer, animated: true)
                        }))

                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func showAlert(_ errorMessage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}

extension SelectApplicantsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfApplicants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "applicantCell", for: indexPath) as? ApplicantViewCell
        let applicant = listOfApplicants[indexPath.row]
        
        cell!.userName.text = applicant.fullName
        cell!.profRoleLabel.text = applicant.profRole
        cell!.locationLabel.text = "\(applicant.city), \(applicant.country)"
        var yearsXP = 0
        applicant.experiences.forEach { xp in
            yearsXP += xp.yearsXp
        }
        cell!.expYearsLabel.text = "\(yearsXP) años de experiencia"
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dictionarySelectedIndexPath[indexPath] = true
        numApplicants += 1
        actionButton.setTitle("\(numApplicants) A la siguiente etapa", for: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        dictionarySelectedIndexPath[indexPath] = false
        numApplicants -= 1
        actionButton.setTitle("\(numApplicants) A la siguiente etapa", for: .normal)
    }
}

extension SelectApplicantsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: 128.0)
    }
}

extension SelectApplicantsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        switch result{
        case .cancelled:
            print("Email cancelado")
        case .failed:
            print("Error al enviar")
        case .saved:
            print("Guardado")
            navigationController?.dismiss(animated: true, completion: nil)
        case .sent:
            print("Email enviado")
            navigationController?.dismiss(animated: true, completion: nil)
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SelectApplicantsViewController {
    func showNoInternet() {
        let alertController = UIAlertController(title: "Ops!",
                                                message: "Lo sentimos, al parecer no hay conexión a internet. Para seguir utilizando la App se requiere una conexión",
                                                preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Enterado", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
