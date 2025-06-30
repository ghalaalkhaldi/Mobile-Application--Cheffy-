
import UIKit

// Custom UITableViewCell subclass for displaying search results
class CHSearchTableViewCell: UITableViewCell {

    // Outlets for UI elements in the cell
    @IBOutlet weak var lblDishCreatedBy: UILabel! // Label for displaying dish creator
    @IBOutlet weak var lblDishName: UILabel! // Label for displaying dish name
    @IBOutlet weak var ImgDish: UIImageView! // Image view for displaying dish image
    @IBOutlet weak var viewMain: UIView! // Main view containing all UI elements
    
    // Called after the view controller has loaded its view hierarchy into memory
    override func awakeFromNib() {
        super.awakeFromNib()
        // Customization code can go here
    }

    // Called when the cell is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Additional customization code can go here
    }
}

