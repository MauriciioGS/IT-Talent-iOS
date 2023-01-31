//
//  Skills2ViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 29/01/23.
//

import UIKit

class Skills2ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popUpSkillsButton: UIButton!
    @IBOutlet weak var segmControl: UISegmentedControl!
    
    var userProfile: UserProfile?
    var userPass = String()
    private var userSoftSkills: [String] = ["Habilidades seleccionadas:"]

    override func viewDidLoad() {
        super.viewDidLoad()

        segmControl.selectedSegmentIndex = 0
        tableView.delegate = self
        tableView.dataSource = self
        setPopUpButton()
    }
    
    private func setPopUpButton() {
        let optionCls = { (action: UIAction) in
            self.userSoftSkills.append(action.title)
            self.tableView.reloadData()
        }
            
        popUpSkillsButton.menu = UIMenu(children: [
            UIAction(title: "Adaptabilidad", state: .on , handler: optionCls),
            UIAction(title: "Networking", handler: optionCls),
            UIAction(title: "Creatividad", handler: optionCls),
            UIAction(title: "Comunicación", handler: optionCls),
            UIAction(title: "Compromiso", handler: optionCls),
            UIAction(title: "Confianza", handler: optionCls),
            UIAction(title: "Liderazgo", handler: optionCls),
            UIAction(title: "Oratoria", handler: optionCls),
            UIAction(title: "Escucha", handler: optionCls),
            UIAction(title: "Motivación", handler: optionCls),
            UIAction(title: "Negociación", handler: optionCls),
            UIAction(title: "Resolución de problemas", handler: optionCls),
            UIAction(title: "Pensamiento crítico", handler: optionCls),
            UIAction(title: "Ética profesional", handler: optionCls),
            UIAction(title: "Manejo del tiempo", handler: optionCls),
            UIAction(title: "Resolución de confictos", handler: optionCls),
            UIAction(title: "Trabajo en equipo", handler: optionCls)
        ])
        
        popUpSkillsButton.showsMenuAsPrimaryAction = true
    }

    @IBAction func continueToExp(_ sender: Any) {
        if (userSoftSkills.count-1 == 0) {
            showAlert("Por favor, selecciona habilidades")
        } else if userSoftSkills.count < 3 {
            showAlert("Por favor, selecciona al menos 2 habilidades blándas")
        } else {
            userSoftSkills.removeFirst()
            userSoftSkills.forEach{ item in
                userProfile?.skills.append(item)
            }
            self.performSegue(withIdentifier: "toExperienceReg", sender: self)
        }
    }
    
    func showAlert(_ errorMesssage: String) {
        // create the alert
        let alert = UIAlertController(title: "Ops!", message: errorMesssage, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? ExperiencesViewController {
            destino.userProfile = userProfile
            destino.userPass = userPass
        }
    }

}

extension Skills2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSoftSkills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if !userSoftSkills.isEmpty {
            cell.textLabel?.text = userSoftSkills[indexPath.row]
        } else {
            cell.textLabel?.text = "Selecciona una skill"
        }
        return cell
    }
    
}
