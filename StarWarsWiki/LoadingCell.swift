import UIKit

class LoadingCell: UITableViewCell {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
