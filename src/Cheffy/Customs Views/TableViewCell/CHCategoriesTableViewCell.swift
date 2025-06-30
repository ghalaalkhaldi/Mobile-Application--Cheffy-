

import UIKit

// Custom UITableViewCell subclass for displaying categories
class CHCategoriesTableViewCell: UITableViewCell {
    
    // Outlets for UI elements in the cell
    @IBOutlet weak var categoriesImageViewCell: UIImageView! // Image view for displaying category image
    @IBOutlet weak var categoriesDishesName: UILabel! // Label for displaying dish name
    @IBOutlet weak var categoriesDishesPostedByCell: UILabel! // Label for displaying dish creator
    @IBOutlet weak var categoriesDishesPriceCell: UILabel! // Label for displaying dish price
    
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

