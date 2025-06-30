

import UIKit // Apple's UIKit framework

class GetStartedViewController: UIViewController { // It inherits from UIViewController, fundamental building block for managing screens in an iOS app.
    
    // Outlet for a connection between the code and a UIButton named "btnGetStarted"
    @IBOutlet weak var btnGetStarted: UIButton!
    
    override func viewDidLoad() { // standard method, called when the view controller's content has been loaded into memory.
        super.viewDidLoad()
        
        // Customize the button appearance
        btnGetStarted.layer.cornerRadius = 17
    }
    
    // Action method for the "Get Started" button
    @IBAction func btnGetStarted_action(_ sender: Any) {
        //tries to create an instance of the pagerroot from your Storyboard.
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PagerRootViewController") as? PagerRootViewController {
            // Push the PagerRootViewController onto the navigation stack
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // Print a message if instantiation failed
            print("Failed to instantiate PagerRootViewController")
        }
    }
}


