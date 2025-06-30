

import UIKit

class CHMyOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderIsBeingPrepared: UILabel!
    @IBOutlet weak var lblWaitForChefResponse: UILabel!
    @IBOutlet weak var btnCloseOrder: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDishPrice: UILabel!
    @IBOutlet weak var lblDishCategory: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var ImgDish: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
