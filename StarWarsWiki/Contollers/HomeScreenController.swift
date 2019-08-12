import UIKit

protocol HomeScreenControllerDelegate: AnyObject {
    func setOpeningIntroText(openingText text: String)
}

class HomeScreenController: UIViewController {
    // MARK: - Properties & Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var fileImageView: UIImageView!
    var films = [Film](){
        didSet{
            DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
            }
        }
    }
    private var episodeTitle = String()
    @IBOutlet weak var buttonView: ButtonView!
    var delegate: HomeScreenControllerDelegate!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callMethods()
    }


    private func callMethods(){
        callApiClientMethod()
        setupDelegation()
        setDefaultSettingsForVC()
        setButtonTargets()
        setBttnState(buttonState: false)
    }

    private func updateFilmOrder(){
        films = films.sorted{ $0.episodeNum < $1.episodeNum
        }
    }

    private func callApiClientMethod(){
        StarWarsApiClient.fetchFilms { [weak self] (result) in
            switch result {
            case .success(let films):
                self?.films = films
                self?.updateFilmOrder()
            case .failure(let error):
                print("\(error)")
            }
        }
    }

    private func setupDelegation(){
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func setDefaultSettingsForVC(){
        fileImageView.image = UIImage(named: "swlogo")
    }

    private func setEpisodeTitleImage(episodeName title: String){
        switch title {
        case "The Phantom Menace":
            fileImageView.image = UIImage(named: Episodes.ep1.rawValue)
        case "Attack of the Clones":
            fileImageView.image = UIImage(named: Episodes.ep2.rawValue)
        case "Revenge of the Sith":
            fileImageView.image = UIImage(named: Episodes.ep3.rawValue)
        case "A New Hope":
            fileImageView.image = UIImage(named: Episodes.ep4.rawValue)
        case "The Empire Strikes Back":
            fileImageView.image = UIImage(named: Episodes.ep5.rawValue)
        case "Return of the Jedi":
            fileImageView.image = UIImage(named: Episodes.ep6.rawValue)
        case "The Force Awakens":
            fileImageView.image = UIImage(named: Episodes.ep7.rawValue)
        default:
            fileImageView.image = UIImage(named: "swlogo")
        }
    }

    private func showListController(){
    }

    private func setButtonTargets(){
        buttonView.planetsBttn.addTarget(self, action: #selector(presentPlanetList), for: .touchUpInside)
        buttonView.readMoreBttn.addTarget(self, action: #selector(presentOpeningIntro), for: .touchUpInside)
        buttonView.peopleBttn.addTarget(self, action: #selector(presentPeopleList), for: .touchUpInside)
    }

    @objc private func presentPlanetList(){
        showListController()
    }

    @objc private func presentOpeningIntro(){
        let row = pickerView.selectedRow(inComponent: 0)
        let text = films[row].openingIntro
        delegate?.setOpeningIntroText(openingText: text)
        let storyboardID = "OpeningIntroController"
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let openingIntroController = storyBoard.instantiateViewController(withIdentifier: storyboardID) as? OpeningIntroController else {
            print("issue with ID")
            return
        }
        self.navigationController?.pushViewController(openingIntroController, animated: true)
    }


    @objc private func presentPeopleList(){
       showListController()
    }

    private func setBttnState(buttonState state: Bool){
        buttonView.peopleBttn.isEnabled = state
        buttonView.readMoreBttn.isEnabled = state
        buttonView.planetsBttn.isEnabled = state
    }
}

//MARK: - Extension
extension HomeScreenController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titles = "\(films[row].title)"
        return titles
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titles = "\(films[row].title)"
        return NSAttributedString(string: titles, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        episodeTitle = "\(films[row].title)"
        setEpisodeTitleImage(episodeName: episodeTitle)
        setBttnState(buttonState: true)
    }
}

extension HomeScreenController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return films.count
    }
}