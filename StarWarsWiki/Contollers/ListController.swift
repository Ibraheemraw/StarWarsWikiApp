import UIKit

class ListController: UIViewController {
    // MARK: - Properties & Outlets
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
    private var allPlanets = [Planet](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var planets = [Planet](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var nextpageURl: String!
    private var searchBarIsEmpty = true
    private var fetchingMore = false
    private var buttonView = ButtonView()
    public var category = String()
    public var currentPage = 1
    public var buttonSelected: ButtonSelected!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callMethods()
        checkButtonStateCommingIn()

    }
    // MARK: - Methods & Actions
    private func checkButtonStateCommingIn(){
        let homescreenVC = storyboard?.instantiateViewController(withIdentifier: "HomeScreenController") as! HomeScreenController
        buttonSelected = homescreenVC.buttonSelected
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if buttonSelected == .peopleBttn {
            allCharacters.shuffle()
            tableView.reloadData()
        } else if buttonSelected == .planetBttn {
            
        }
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "show detail info"{
                if let destination = segue.destination as? DetailController {
                    if let cellIndex = tableView.indexPathForSelectedRow?.row {let person = allCharacters[cellIndex]
                        destination.person = person
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
        setupCustomCell()
    }

    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    private func callApiClientMethod(){
        if buttonSelected == .peopleBttn {
            StarWarsApiClient.fetchPeople(pageNumber: currentPage) { [weak self](result) in
                switch result {
                case .success(let people):
                    self?.allCharacters = people
                case .failure(let error):
                   self?.callAlert(alertTitle: "Error", alertMessage: "\(error)")
                }
            }
        } else if buttonSelected == .planetBttn {
            StarWarsApiClient.fetchPlanets(pageNumber: currentPage) { [weak self] (result) in
                switch result {
                case .success(let planet):
                    self?.allPlanets = planet
                case .failure(let error):
                    self?.callAlert(alertTitle: "Error", alertMessage: "\(error)")
                }
            }
        }
    }

    func beginBatchFetch(){
        fetchingMore = true
        currentPage += 1
        if buttonSelected == .peopleBttn {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            StarWarsApiClient.fetchPeople(pageNumber: self.currentPage) { [weak self](result) in
                switch result {
                case .success(let people):
                    self?.allCharacters.append(contentsOf: people)
                    self?.fetchingMore = false
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.65){
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    self?.callAlert(alertTitle: "Error", alertMessage: "\(error)")
                }
            }
        } else if buttonSelected == .planetBttn{
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            StarWarsApiClient.fetchPlanets(pageNumber: self.currentPage) { [weak self](result) in
                switch result {
                case .success(let people):
                    self?.allPlanets.append(contentsOf: people)
                    self?.fetchingMore = false
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.65){
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    self?.callAlert(alertTitle: "Error", alertMessage: "\(error)")
                }
            }
            
        }
        
    }
    private func setupCustomCell(){
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
    }
}

//MARK: - Extensions
extension ListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buttonSelected == .peopleBttn {
            if section == 0 {
                if searchBarIsEmpty {
                    return allCharacters.count
                } else {
                    return characters.count
                }
            } else if section == 1 {
                return 1
            }
        } else if buttonSelected == .planetBttn {
            if section == 0 {
                if searchBarIsEmpty {
                    return allPlanets.count
                } else {
                    return planets.count
                }
            } else if section == 1 {
                return 1
            }
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if buttonSelected == .peopleBttn {
            if indexPath.section == 0 {
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
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
                cell.spinner.startAnimating()
                return cell
            }
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                if searchBarIsEmpty {
                    let settingCells = allPlanets[indexPath.row]
                    cell.textLabel?.text = settingCells.name
                } else {
                    let settingCells = planets[indexPath.row]
                    cell.textLabel?.text = settingCells.name
                }
                cell.textLabel?.textColor = .white
                cell.backgroundColor = .clear
                cell.textLabel?.textAlignment = .center
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
                cell.spinner.startAnimating()
                return cell
            }
        }
    }
}

extension ListController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print("row: \(row)")
        performSegue(withIdentifier: "show detail info", sender: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
}

extension ListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if buttonSelected == .peopleBttn {
            if searchText == ""{
                searchBarIsEmpty = true
            } else {
                searchBarIsEmpty = false
                characters = allCharacters.filter{$0.name.contains(searchText)}
                tableView.reloadData()
            }
        } else if buttonSelected == .planetBttn {
            if searchText == ""{
                searchBarIsEmpty = true
            } else {
                searchBarIsEmpty = false
                planets = allPlanets.filter{$0.name.contains(searchText)}
                tableView.reloadData()
            }
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

