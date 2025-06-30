

import UIKit

class CHMyDishesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDishPrice: UILabel!
    @IBOutlet weak var lblDishCategory: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var imgDish: UIImageView!
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
