
import UIKit
import Firebase
import SDWebImage
import ChatSDK
import ChatSDKFirebase

class CHTabBarViewController: UITabBarController,UITabBarControllerDelegate {
    
    var objCurrentUser = CHUserModel()
    var categories: [Category] = []
    var arrObjDishes : [CHDishesModel] = []
    var arrObjPopularDishes : [CHDishesModel] = []
    
    var firstViewController: CHAddDishesViewController!
    var secondViewController: CHMessagesViewController!
    var currentViewController: UIViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        
//        tabBarItem.image = UIImage(named: "plusIcon")
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid ?? "")
        { array, isSuccessfull in
            if isSuccessfull
            {
                self.objCurrentUser = array![0] as! CHUserModel
                if self.objCurrentUser.userType == "Resturant"
                {
                    let tabToChange  = 2
                    let viewCon = self.tabBarController?.viewControllers?[tabToChange]
                    
                    viewCon?.tabBarItem.title = "Chat"
                    viewCon?.tabBarItem.image = UIImage(systemName: "message")
                    viewCon?.tabBarItem.selectedImage = UIImage(systemName: "message")
                    
                    let tabToFourth = 3
                    let viewFourth = self.tabBarController?.viewControllers?[tabToFourth]
                    
                    viewFourth?.tabBarItem.title = "Chef"
                    viewFourth?.tabBarItem.image = UIImage(systemName: "fork.knife")
                    viewFourth?.tabBarItem.selectedImage = UIImage(systemName: "fork.knife")
                }
                else
                {
                    let tabToChange  = 2
                    let viewCon = self.tabBarController?.viewControllers?[tabToChange]
                    
                    viewCon?.tabBarItem.title = "Add"
                    viewCon?.tabBarItem.image = UIImage(systemName: "plus")
                    viewCon?.tabBarItem.selectedImage = UIImage(systemName: "plus")
                    
                    let tabToFourth  = 3
                    let viewFourth = self.tabBarController?.viewControllers?[tabToFourth]
                    
                    viewFourth?.tabBarItem.title = "Restaurant"
                    viewFourth?.tabBarItem.image = UIImage(systemName: "building")
                    viewFourth?.tabBarItem.selectedImage = UIImage(systemName: "building")
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
