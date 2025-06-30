
import UIKit

// Custom UICollectionViewCell subclass for displaying all dishes
class AllDishesCollectionView: UICollectionViewCell {
    
    // Outlets for UI elements in the cell
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblCheifName: UILabel! // Label for displaying chef's name
    @IBOutlet weak var allDishesText: UILabel! // Label for displaying all dishes text
    @IBOutlet weak var allDishesImages: UIImageView! // Image view for displaying dish image
    @IBOutlet weak var allDishesViewBackground: UIView! // View serving as the background of the cell
    
    // Called after the view controller has loaded its view hierarchy into memory
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional customization code can go here
        
        // Make the image view circular
        allDishesImages.layer.cornerRadius = allDishesImages.frame.height / 2
        allDishesImages.clipsToBounds = true
        
        // Make the background view rounded
        allDishesViewBackground.layer.cornerRadius = 10 // Set the corner radius
        allDishesViewBackground.layer.masksToBounds = true // Clip subviews to the rounded corners
    }
}

