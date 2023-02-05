//
//  ProfProfileViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 04/02/23.
//

import UIKit
import MessageUI

class ProfProfileViewController: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profRoleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var xpCollectionView: UICollectionView!
    @IBOutlet weak var skillsTableView: UITableView!
    
    var userSelected: UserProfile?
    private var xpCellWidth: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        nameLabel.text = userSelected!.fullName
        profRoleLabel.text = userSelected!.profRole
        locationLabel.text = "\(userSelected!.city), \(userSelected!.country)"
        
        xpCollectionView.register(UINib(nibName: "ProfesionalProfileViewCell", bundle: nil), forCellWithReuseIdentifier: "xpCell")
        xpCollectionView.delegate = self
        xpCollectionView.dataSource = self
        xpCellWidth = xpCollectionView.bounds.width - (xpCollectionView.bounds.width / 4)
        
        skillsTableView.dataSource = self
        skillsTableView.delegate = self
        
    }

    @IBAction func contact(_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlert("El dispositivo no puede enviar emails")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([userSelected!.email])
        composer.setSubject("Contacto oportunidad laboral")
        present(composer, animated: true)
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

extension ProfProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userSelected!.experiences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let xpCell = collectionView.dequeueReusableCell(withReuseIdentifier: "xpCell", for: indexPath) as? ProfesionalProfileViewCell
        let xp = userSelected?.experiences[indexPath.row]
        
        xpCell!.jobNameLabel.text = xp!.charge
        xpCell!.enterpriseLabel.text = xp!.enterprise
        xpCell!.modeLabel.text = xp!.mode
        xpCell!.locationLabel.text = xp!.city
        xpCell!.periodLabel.text = xp!.period
        xpCell!.textAch.text = xp!.achievements
        return xpCell!
    }
    
}

extension ProfProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: xpCellWidth!, height: 194)
    }
}

extension ProfProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSelected!.skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = userSelected?.skills[indexPath.row]
        return cell
    }
    
    
}

extension ProfProfileViewController: MFMailComposeViewControllerDelegate {
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
