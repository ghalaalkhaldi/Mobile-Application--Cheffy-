

import UIKit

import UIKit

// Custom UICollectionViewCell subclass for adding dishes in a UICollectionView
class CHAddDishesCollectionViewCell: UICollectionViewCell {
    
    // Outlets for UI elements in the cell
    @IBOutlet weak var btnDeleteImage: UIButton! // Button for deleting the dish image
    @IBOutlet weak var addNewDishesImageCell: UIImageView! // Image view for displaying the dish image
    
    // Called after the view controller has loaded its view hierarchy into memory
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

