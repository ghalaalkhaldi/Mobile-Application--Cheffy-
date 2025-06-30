
import UIKit
import Firebase
import SDWebImage
import ChatSDK
import ChatSDKFirebase

class CHAddRestaurantAndChatViewController: UIViewController,UITabBarDelegate {
    
    
    @IBOutlet weak var containerView: UIView!
    var objCurrentUser = CHUserModel()
    var categories: [Category] = []
    var arrObjDishes : [CHDishesModel] = []
    var arrObjPopularDishes : [CHDishesModel] = []
    
    
    var firstViewController: CHAddDishesViewController!
    var secondViewController: CHMessagesViewController!
    
    // Reference to the currently displayed view controller
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid ?? "")
        { array, isSuccessfull in
            if isSuccessfull
            {
                self.objCurrentUser = array![0] as! CHUserModel
                if self.objCurrentUser.userType == "Resturant"
                {
                    self.loadViewController(type: self.objCurrentUser.userType ?? "")
                    let tabToChange  = 2
                    let viewCon = self.tabBarController?.viewControllers?[tabToChange]
                    
                    viewCon?.tabBarItem.title = "Chat"
                    viewCon?.tabBarItem.image = UIImage(systemName: "message")
                    viewCon?.tabBarItem.selectedImage = UIImage(systemName: "message")
                }
                else
                {
                    self.loadViewController(type: self.objCurrentUser.userType ?? "")
                    let tabToChange  = 2
                    let viewCon = self.tabBarController?.viewControllers?[tabToChange]
                    
                    viewCon?.tabBarItem.title = "Add"
                    viewCon?.tabBarItem.image = UIImage(systemName: "plus")
                    viewCon?.tabBarItem.selectedImage = UIImage(systemName: "plus")
                }
            }
            else
            {
                print("user not found")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
}

private extension CHAddRestaurantAndChatViewController {
    
    func loadViewController(type: String) {
        currentViewController?.removeFromParent()
        currentViewController?.view.removeFromSuperview()
        
        if type == "Resturant"
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CHMessagesViewController") as! CHMessagesViewController
            addViewController(vc)
        }
        else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CHAddDishesViewController") as! CHAddDishesViewController
            addViewController(vc)
        }
    }
    
    func addViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 80)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        currentViewController = viewController
    }
}
