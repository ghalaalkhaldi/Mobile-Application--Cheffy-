

import UIKit

// Custom UITableViewCell subclass for displaying restaurant information
class CHResturantTableViewCell: UITableViewCell {
    
    // Outlets for UI elements in the cell
    @IBOutlet weak var resturantImageCell: UIImageView! // Image view for displaying restaurant image
    @IBOutlet weak var resturantName: UILabel! // Label for displaying restaurant name
    @IBOutlet weak var resturantAddress: UILabel! // Label for displaying restaurant address
    @IBOutlet weak var resturantContactNo: UILabel! // Label for displaying restaurant contact number
    
    // Called after the view controller has loaded its view hierarchy into memory
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional customization code can go here
        
        // Set selection style to none
        super.selectionStyle = .none
    }

    // Called when the cell is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Additional customization code for selected state can go here
    }
}

