//
//  SkillsViewController.swift
//  IT Talent
//
//  Created by Mauricio García S on 29/01/23.
//

import UIKit

class SkillsViewController: UIViewController {
    
    @IBOutlet weak var segmControl: UISegmentedControl!
    @IBOutlet weak var popUpSkillsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    var userProfile: UserProfile?
    private var userSkills: [String] = ["Habilidades seleccionadas:"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmControl.selectedSegmentIndex = 0
        tableView.dataSource = self
        tableView.delegate = self
        setPopUpButton()
    }
    
    private func setPopUpButton() {
        let optionCls = { (action: UIAction) in
            self.userSkills.append(action.title)
            self.tableView.reloadData()
        }
            
        popUpSkillsButton.menu = UIMenu(children: [
            UIAction(title: "Python", state: .on , handler: optionCls),
            UIAction(title: "R", handler: optionCls),
            UIAction(title: "Django", handler: optionCls),
            UIAction(title: "Flask", handler: optionCls),
            UIAction(title: "Java", handler: optionCls),
            UIAction(title: "Spring", handler: optionCls),
            UIAction(title: "Hibernate", handler: optionCls),
            UIAction(title: "C", handler: optionCls),
            UIAction(title: "C++", handler: optionCls),
            UIAction(title: "C#", handler: optionCls),
            UIAction(title: "Golang", handler: optionCls),
            UIAction(title: "Elixir", handler: optionCls),
            UIAction(title: "PHP", handler: optionCls),
            UIAction(title: "Laravel", handler: optionCls),
            UIAction(title: ".NET", handler: optionCls),
            UIAction(title: "Ruby", handler: optionCls),
            UIAction(title: "Perl", handler: optionCls),
            UIAction(title: "Fortran", handler: optionCls),
            UIAction(title: "Shell Script", handler: optionCls),
            UIAction(title: "Dart", handler: optionCls),
            UIAction(title: "Flutter", handler: optionCls),
            UIAction(title: "Android", handler: optionCls),
            UIAction(title: "Kotlin", handler: optionCls),
            UIAction(title: "Firebase", handler: optionCls),
            UIAction(title: "iOS", handler: optionCls),
            UIAction(title: "Swift", handler: optionCls),
            UIAction(title: "Objective-C", handler: optionCls),
            UIAction(title: "React", handler: optionCls),
            UIAction(title: "JavaScript", handler: optionCls),
            UIAction(title: "TypeScript", handler: optionCls),
            UIAction(title: "Node.JS", handler: optionCls),
            UIAction(title: "Angular", handler: optionCls),
            UIAction(title: "Vue", handler: optionCls),
            UIAction(title: "jQuery", handler: optionCls),
            UIAction(title: "GCP", handler: optionCls),
            UIAction(title: "AWS", handler: optionCls),
            UIAction(title: "Azure", handler: optionCls),
            UIAction(title: "Oracle Cloud", handler: optionCls),
            UIAction(title: "SQL", handler: optionCls),
            UIAction(title: "MySQL", handler: optionCls),
            UIAction(title: "T-SQL", handler: optionCls),
            UIAction(title: "PL-SQL", handler: optionCls),
            UIAction(title: "ProstreSQL", handler: optionCls),
            UIAction(title: "SQLServer", handler: optionCls),
            UIAction(title: "MongoDB", handler: optionCls),
            UIAction(title: "MariaDB", handler: optionCls),
            UIAction(title: "Cassandra", handler: optionCls),
            UIAction(title: "Salesforce", handler: optionCls),
            UIAction(title: "Arduino", handler: optionCls),
            UIAction(title: "Ambassador", handler: optionCls),
            UIAction(title: "Scrum", handler: optionCls),
            UIAction(title: "Agile", handler: optionCls),
            UIAction(title: "Jenkins", handler: optionCls),
            UIAction(title: "Data Network", handler: optionCls),
            UIAction(title: "Git", handler: optionCls),
            UIAction(title: "Linux", handler: optionCls),
        ])
        
        popUpSkillsButton.showsMenuAsPrimaryAction = true
    }

    @IBAction func continueRegister(_ sender: Any) {
        if (userSkills.count-1 == 0) {
            showAlert("Por favor, selecciona habilidades")
        } else if userSkills.count < 3 {
            showAlert("Por favor, selecciona al menos 2 habilidades tecnológicas")
        } else {
            userSkills.removeFirst()
            userProfile?.skills = userSkills
            self.performSegue(withIdentifier: "toSoftSkills", sender: self)
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
        if let destino = segue.destination as? Skills2ViewController {
            destino.userProfile = userProfile
        }
    }

}

extension SkillsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSkills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell")!
        if !userSkills.isEmpty {
            cell.textLabel?.text = userSkills[indexPath.row]
        } else {
            cell.textLabel?.text = "Selecciona una skill"
        }
        return cell
    }
    
}
