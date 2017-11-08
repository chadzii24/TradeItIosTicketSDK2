import UIKit

class TradeItOrderTableViewHeader: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(title: String, titleDate: String, isCancelable: Bool = false) {
        self.titleLabel?.text = title
        self.titleDateLabel?.text = titleDate
        self.contentView.backgroundColor = UIColor.tradeItlightGreyHeaderBackgroundColor
        if isCancelable {
            self.detailLabel?.text = "Swipe to cancel"
        } else {
            self.detailLabel?.text = ""
        }
    }
    
}
