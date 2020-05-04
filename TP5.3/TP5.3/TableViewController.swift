

import UIKit

class TableViewController: UITableViewController {
    
    var sportPeoples: [Athlete]!
    var athletePeoples : [Athlete]!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromjson()
        tableView.reloadData()
        
        searchBar.delegate = self
    }
    
    func getDataFromjson() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Athlete", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return
        }
        
        let decoder = JSONDecoder()
        do {
            sportPeoples = try decoder.decode([Athlete].self, from: data)
            athletePeoples = sportPeoples
        } catch {
            print(error)
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athletePeoples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TableViewCell
        
        let athlete = athletePeoples[indexPath.row]
        cell.nameLabel.text = athlete.name
        cell.ageLabel.text = String(athlete.age)
        
        return cell
    }
    
    @IBAction func sortByName(_ sender: Any) {
        athletePeoples.sort(by: {$0.name < $1.name})
        tableView.reloadData()
    }
    
    @IBAction func sortByAge(_ sender: Any) {
        athletePeoples.sort(by: {$0.age < $1.age})
        tableView.reloadData()
    }
    
}

//Implementing UISearchBar Function
extension TableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        athletePeoples = sportPeoples.filter({ athlete -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return athlete.name.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return athlete.age < 30  }
                return athlete.name.lowercased().contains(searchText.lowercased()) &&
                    athlete.age < 30
            case 2:
                if searchText.isEmpty { return athlete.age > 30 }
                return athlete.name.lowercased().contains(searchText.lowercased()) &&
                    athlete.age > 30
            default:
                return false
            }
        })
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            athletePeoples = sportPeoples
        case 1:
            athletePeoples = sportPeoples.filter({ athlete -> Bool in
                athlete.age < 30
            })
        case 2:
            athletePeoples = sportPeoples.filter({ athlete -> Bool in
                athlete.age >= 30
            })
        default:
            break
        }
        tableView.reloadData()
    }
    
}
