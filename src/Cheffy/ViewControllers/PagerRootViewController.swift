

import UIKit

class PagerRootViewController: UIPageViewController {
    
    // Current page index
    var currentPage = 0 // keep track of the currently displayed page's index.
    
    // UIPageControl appearance
    var pageController = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    
    // Array holding the view controllers to display in the page view controller
    lazy var vcArray: [UIViewController] = { //An array to hold the view controllers that will be displayed as pages.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcOne = storyboard.instantiateViewController(withIdentifier: "WalkThroughPageOneViewController")
        let vcTwo = storyboard.instantiateViewController(withIdentifier: "WalkThroughPageTwoViewController")
        let vcThree = storyboard.instantiateViewController(withIdentifier: "WalkThroughPageThreeViewController")
        return [vcOne, vcTwo, vcThree]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source for the page view controller
        self.dataSource = self //Sets itself PagerRootViewController as the data source for the page view controller.
        
        // Set the initial view controller to be displayed as the first page.
        if let vc = vcArray.first {
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
        
        // Customize page control appearance
        pageController.currentPageIndicatorTintColor = .clear
        pageController.pageIndicatorTintColor = .clear
    }
    
    // Ensure that subviews (specifically UIScrollView) match the view's bounds
    override func viewDidLayoutSubviews() { //ensures that the UIScrollView fills the entire view's bounds.
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.frame = self.view.bounds
            }
        }
        super.viewDidLayoutSubviews()
    }
}

// Extension to handle UIPageViewControllerDataSource methods
extension PagerRootViewController: UIPageViewControllerDataSource {
    
    // Method to get the view controller before the current one
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.lastIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 && previousIndex < vcArray.count else { return nil }
        currentPage = previousIndex
        return vcArray[previousIndex]
    }
    
    // Method to get the view controller after the current one
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.lastIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex >= 0 && nextIndex < vcArray.count else { return nil }
        currentPage = nextIndex
        return vcArray[nextIndex]
    }
    
    // Method to specify the index of the selected page
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }
    
    // Method to specify the total number of pages
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcArray.count
    }
}

