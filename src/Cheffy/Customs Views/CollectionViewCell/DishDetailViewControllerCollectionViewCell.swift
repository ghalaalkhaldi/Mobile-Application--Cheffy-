

import UIKit

// Custom UICollectionViewCell subclass for displaying dish details in the DishDetailViewController
class DishDetailViewControllerCollectionViewCell: UICollectionViewCell {
 
    // Outlet for the image view displaying the dish detail
    @IBOutlet weak var DishDetailControllerCellImage: UIImageView!
    
    // Called after the view controller has loaded its view hierarchy into memory
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional customization code can go here
        
       
    }
}
