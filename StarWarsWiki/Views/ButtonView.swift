import UIKit

class ButtonView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var planetsBttn: UIButton!
    @IBOutlet weak var readMoreBttn: UIButton!

    @IBOutlet weak var peopleBttn: UIButton!

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // load the nib file
        Bundle.main.loadNibNamed("ButtonView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

