import UIKit

class DetailController: UIViewController {
    // MARK: - Properties & Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var forthLabel: UILabel!
    public var person: Person!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callMethods()
    }
    // MARK: - Methods & Actions
    private func callMethods(){
        setupDetailObjects()
    }
    private func setupDetailObjects(){
        nameLabel.text =  person.name
        firstLabel.text = "Hair Color: " + person.hairColor
        secondLabel.text = "Eye Color: " + person.eyeColor
        thirdLabel.text = "Birth Year: " + person.birthYear
        forthLabel.text = "Created Date: " + person.created
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
