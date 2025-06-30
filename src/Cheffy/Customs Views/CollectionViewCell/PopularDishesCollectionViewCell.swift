

import UIKit

// Custom UICollectionViewCell subclass for displaying popular dishes
class PopularDishesCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var lblRating: UILabel!
    // Outlets for UI elements in the cell
    @IBOutlet weak var lblCheifName: UILabel! // Label for displaying chef's name
    @IBOutlet weak var cellBackgroundView: UIView! // View serving as the background of the cell
    @IBOutlet weak var popularDishesImages: UIImageView! // Image view for displaying popular dish image
    @IBOutlet weak var popularDishesName: UILabel! // Label for displaying popular dish name
    
    // Called after the view controller has loaded its view hierarchy into memory
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional customization code can go here
        
        // Make the background view rounded
        cellBackgroundView.layer.cornerRadius = 10 // Set the corner radius
        cellBackgroundView.layer.masksToBounds = true // Clip subviews to the rounded corners
    }
}

