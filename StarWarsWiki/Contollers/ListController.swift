import UIKit

class ListController: UIViewController {
    // MARK: - Properties & Outlets
    public var specificCharacters = [String](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var allCharacters = [Person](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var characters = [Person](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var nextpageURl: String!
    private var searchBarIsEmpty = true
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callMethods()
    }
    // MARK: - Methods & Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show detail info"{
            if let destination = segue.destination as? DetailController {
                if let cellIndex = tableView.indexPathForSelectedRow?.row {
                    let person = allCharacters[cellIndex]

                }
            }
        } else {
            print("Wrong ID")
        }
    }
    
    private func callMethods(){
        setupDelegations()
        callApiClientMethod()
        setVCSettings()
        
    }
    private func setupDelegations(){
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func setVCSettings(){
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func callApiClientMethod(){
        StarWarsApiClient.fetchPeople { [weak self](result) in
            switch result {
            case .success(let people):
                self?.allCharacters = people
                print("number of people",self?.allCharacters.count ?? [Person]())
            //                self?.nextpageURl = self?.people.next
            case .failure(let error):
                print("Network Error: \(error)")
            }
        }
    }
    
}

//MARK: - Extensions
extension ListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return specificCharacters.count
        if searchBarIsEmpty {
            return allCharacters.count
        } else {
            return characters.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searchBarIsEmpty {
            let settingCells = allCharacters[indexPath.row]
            cell.textLabel?.text = settingCells.name
        } else {
            let settingCells = characters[indexPath.row]
            cell.textLabel?.text = settingCells.name
        }
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    
}

extension ListController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print("row: \(row)")
        performSegue(withIdentifier: "show detail info", sender: indexPath)
    }
}

extension ListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            searchBarIsEmpty = true
        } else {
            searchBarIsEmpty = false
            characters = allCharacters.filter{$0.name.contains(searchText)}
            tableView.reloadData()
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        tableView.reloadData()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        return
    }
}

