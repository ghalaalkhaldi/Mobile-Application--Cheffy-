

import UIKit

// Custom UICollectionViewCell subclass for displaying categories
class CategoriesCollectionViewCell: UICollectionViewCell {
    
    // Outlets for UI elements in the cell
    @IBOutlet weak var categoriesImage: UIImageView! // Image view for displaying category image
    @IBOutlet weak var categoriesName: UILabel! // Label for displaying category name
    
    // Called after the view controller has loaded its view hierarchy into memory
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional customization code can go here
        
        // Make the image view circular
        categoriesImage.layer.cornerRadius = categoriesImage.frame.size.width / 2
        categoriesImage.clipsToBounds = true
    }
}

