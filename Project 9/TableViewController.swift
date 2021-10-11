//
//  TableViewController.swift
//  MyTrainerProject
//
//  Created by Sinan Kulen on 25.09.2021.
//

import UIKit

class TableViewController: UITableViewController {

    var petitions = [Petition]()
    var filtrePetition = [Petition]()
    var savePetition = [Petition]()
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(creditButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(filterButton))
        
        title = "Are you initializer ?"
     
        performSelector(inBackground: #selector(filtreAlert), with: nil)
        performSelector(onMainThread: #selector(fetchJSON), with: nil, waitUntilDone: false)
    }
    
    @objc func fetchJSON() {
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json" }
        else { urlString = "https://www.hackingwithswift.com/samples/petitions-2.json" }
        
        
        if let url = URL(string: self.urlString) {
            if let data = try? Data(contentsOf: url) {
                self.parse(json : data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func parse(json : Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(tableView.reloadData), with: nil, waitUntilDone: false)
            savePetition = petitions
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func creditButton() {
        let ac = UIAlertController(title: "Credit", message: "The data comes from API the White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func filterButton() {
        let filterAlert = UIAlertController(title: "Please writing filter to textField", message: nil, preferredStyle: .alert)
        filterAlert.addTextField()
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) { _ in
            guard let filter = filterAlert.textFields?[0].text else { return }
            self.filtreAlert(filter)
        }
        
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in
            self.resetButton()
        }
        
        filterAlert.addAction(resetAction)
        filterAlert.addAction(filterAction)
        present(filterAlert, animated: true)
    }
    
    @objc func filtreAlert(_ word: String) {
        filtrePetition.removeAll()
        for petition in savePetition {
            if petition.body.lowercased().contains(word.lowercased()) {
                filtrePetition.append(petition)
            }
        }
        if filtrePetition.isEmpty { return }
        petitions = filtrePetition
        tableView.reloadData()
    }
    
    func resetButton() {
        petitions = savePetition
        tableView.reloadData()
    }
}
