
import UIKit

class CHMyOrdersChefTableViewCell: UITableViewCell {
    @IBOutlet weak var btnPreparing: UIButton!
    @IBOutlet weak var btnOrderReady: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPrepare: UIButton!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var imgDish: UIImageView!
    @IBOutlet weak var lblDishTimestamp: UILabel!
    @IBOutlet weak var lblDishPrice: UILabel!
    @IBOutlet weak var lblDishCategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
