

import UIKit

class WalkThroughPageTwoViewController: UIViewController {
    
    // Outlet for the "Get Started" button
    @IBOutlet weak var btnGetStarted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the page control if found as a subview
        for view in view.subviews {
            if let pageControl = view as? UIPageControl {
                pageControl.isHidden = true
            }
        }
        
        // Customize the "Get Started" button appearance
        btnGetStarted.layer.cornerRadius = 17
    }
    
    // Action method for the "Get Started" button
    @IBAction func btnGetStarted_action(_ sender: Any) {
        // Navigate to the next page (WalkThroughPageThreeViewController)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WalkThroughPageThreeViewController") as? WalkThroughPageThreeViewController {
            navigationController?.pushViewController(vc, animated: false)
        } else {
            print("Failed to instantiate WalkThroughPageThreeViewController")
        }
    }
}

