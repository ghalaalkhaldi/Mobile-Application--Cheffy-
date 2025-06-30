

import UIKit

class CHMyChefTableViewCell: UITableViewCell {

    @IBOutlet weak var lblChefTimestamp: UILabel!
    @IBOutlet weak var lblChefCategory: UILabel!
    @IBOutlet weak var lblChefPhoneNo: UILabel!
    @IBOutlet weak var lblChefEmail: UILabel!
    @IBOutlet weak var lblChefName: UILabel!
    @IBOutlet weak var imgDish: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
