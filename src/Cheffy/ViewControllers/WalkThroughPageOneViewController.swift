

import UIKit

class WalkThroughPageOneViewController: UIViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    // Outlet for the "Get Started" button
    @IBOutlet weak var btnGetStarted: UIButton!
    
    // Lazy initialization of an array holding view controllers
    lazy var vcArray: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcOne = storyboard.instantiateViewController(withIdentifier: "WalkThroughPageOneViewController")
        let vcTwo = storyboard.instantiateViewController(withIdentifier: "WalkThroughPageTwoViewController")
        let vcThree = storyboard.instantiateViewController(withIdentifier: "WalkThroughPageThreeViewController")
        return [vcOne, vcTwo, vcThree]
    }()
    
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
    
    @IBAction func btnSkip_Pressed(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    // Action method for the "Get Started" button
    @IBAction func btnGetStarted_action(_ sender: Any) {
        // Navigate to the next page (WalkThroughPageTwoViewController)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WalkThroughPageTwoViewController") as? WalkThroughPageTwoViewController {
            navigationController?.pushViewController(vc, animated: false)
        } else {
            print("Failed to instantiate WalkThroughPageTwoViewController")
        }
    }
}

// Extension to conform to UIPageViewControllerDelegate
extension PagerRootViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            // Swipe completed, update UI or perform actions
        }
    }
}

