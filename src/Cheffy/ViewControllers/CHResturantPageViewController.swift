

import Foundation
import UIKit
import SVProgressHUD
import Firebase
import SDWebImage
import ChatSDK
import ChatSDKFirebase

// Structure to hold restaurant information
struct Restaurant {
    let name: String
    let imageName: String
    let address: String
    let phoneNo: String
}

class CHResturantPageViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var resturantTableView: UITableView!
    @IBOutlet weak var lblTitleName: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    // Properties
    var arrObjResturantsTemp : [CHUserModel] = []
    var arrObjResturants : [CHUserModel] = []
    var arrObjChef : [CHUserModel] = []
    var userType = ""
    var isChatOpenAlready = false
    var isFromCategory = false
    var objCurrentUser = CHUserModel()
    var categories: [Category] = []
    var arrObjDishes : [CHDishesModel] = []
    var arrObjPopularDishes : [CHDishesModel] = []
    
    // Array to hold restaurant models fetched from API
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if self.isFromCategory
        {
            self.btnBack.isHidden = false
        }
        else{
            self.btnBack.isHidden = true
        }
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid ?? "")
        { array, isSuccessfull in
            if isSuccessfull
            {
                
                self.objCurrentUser = array![0] as! CHUserModel
                if self.objCurrentUser.userType == "Resturant"
                {
                    self.getAllUsers()
                    let tabToFourth = 3
                    let viewFourth = self.tabBarController?.viewControllers?[tabToFourth]
                    
                    viewFourth?.tabBarItem.title = "Chef"
                    viewFourth?.tabBarItem.image = UIImage(systemName: "fork.knife")
                    viewFourth?.tabBarItem.selectedImage = UIImage(systemName: "fork.knife")
                    self.lblTitleName.text = "Chef"
                }
                else
                {
                    self.getAllUsers()
                    let tabToFourth  = 3
                    let viewFourth = self.tabBarController?.viewControllers?[tabToFourth]
                    
                    viewFourth?.tabBarItem.title = "Restaurant"
                    viewFourth?.tabBarItem.image = UIImage(systemName: "building")
                    viewFourth?.tabBarItem.selectedImage = UIImage(systemName: "building")
                    self.lblTitleName.text = "Restaurant"
                }
            }
            else
            {
              print("user not found")
            }
        }
    }
    
    func getAllUsers()
    {
        self.arrObjResturants = []
        self.arrObjChef = []
        self.arrObjResturantsTemp = []
        SVProgressHUD.show()
        CHProfileAPIManager().getAllUsers { array, isSuccessfull in
            if isSuccessfull
            {
                // Update restaurant array and reload table view
                SVProgressHUD.dismiss()
                self.arrObjResturantsTemp = array as! [CHUserModel]
                for i in self.arrObjResturantsTemp
                {
                    let temp = i.userType
                    if temp == "Resturant"
                    {
                        self.arrObjResturants.append(i)
                    }
                    else if temp == "Chef"
                    {
                        self.arrObjChef.append(i)
                    }
                }
                self.resturantTableView.reloadData()
            }
            else
            {
                SVProgressHUD.dismiss()
                // Handle failure to fetch restaurants
            }
        }
    }
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func call(number:String)
    {
        if let phoneURL = URL(string: "tel://\(number)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneURL) {
                application.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                // Handle error, the device can't make phone calls
                print("Device cannot make phone calls.")
            }
        }
    }
    func showInMap(address:String)
    {
        
        // Format the address to be URL-friendly
        let formattedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Google Maps URL scheme
        if let googleMapsURL = URL(string: "comgooglemaps://?q=\(formattedAddress)"), UIApplication.shared.canOpenURL(googleMapsURL) {
            // If Google Maps is installed, open the address in Google Maps
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else {
            // If Google Maps is not installed, open the address in Apple Maps
            if let appleMapsURL = URL(string: "http://maps.apple.com/?q=\(formattedAddress)") {
                UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
            }
            
        }
    }
    func contactResturant(objCurrentUser:CHUserModel,objResturant:CHUserModel)
    {
        
        let objOtherUser = objResturant
        let wrapper1: CCUserWrapper = CCUserWrapper.user(withEntityID: self.objCurrentUser.userId)
        wrapper1.metaOn()
        let user1 : PUser = wrapper1.model()
        user1.setName(self.objCurrentUser.firstName)
        wrapper1.push()
        let wrapper2:CCUserWrapper = CCUserWrapper.user(withEntityID: objOtherUser.userId)
        wrapper2.metaOn()
        let user2 : PUser = wrapper2.model()
        user2.setName(objOtherUser.firstName)
        wrapper2.push()
        let users : Array = [user1, user2]

        // Check if chat is already open
        let array = BChatSDK.core().threads(with: bThreadType1to1)
        let arrayThread = array as! [PThread]
        for i in arrayThread {
            if i.otherUser().entityID() == objOtherUser.userId {
                self.isChatOpenAlready = true
                i.otherUser().entityID()
                i.markRead()
                let chatViewController = BChatSDK.ui().chatViewController(with:i)
                let controller = BChatViewController.init(thread: i)
                controller?.updateTitle()
                controller?.doViewWillDisappear(true)
                i.markRead()
                chatViewController?.modalPresentationStyle = .formSheet
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.present(controller!, animated: true)
            }
        }

        // If chat is not open, create new chat thread
        if isChatOpenAlready == false {
            BChatSDK.core().createThread(withUsers: users , threadCreated: {(error: Error?, thread:PThread?) in
                if ((error) != nil) {
                    print(error.debugDescription)
                } else {
                    let cvc = BChatSDK.ui().chatViewController(with: thread)
                    self.navigationController?.navigationBar.isHidden = false
                    self.navigationController?.modalPresentationStyle = .formSheet
                    self.navigationController?.present(cvc!, animated: true)
                }
            })
        }
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension CHResturantPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objCurrentUser.userType == "Resturant"
        {
            return self.arrObjChef.count
        }
        else
        {
            return self.arrObjResturants.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHResturantTableViewCell", for: indexPath) as! CHResturantTableViewCell
        
        if objCurrentUser.userType == "Resturant"
        {
            cell.resturantImageCell.layer.cornerRadius = 10
            let restaurant = self.arrObjChef[indexPath.row]
            let resturantImage = restaurant.certificatesImages as! [CHDishImageModel]
            if resturantImage.count > 0 {
                cell.resturantImageCell.sd_setImage(with: URL(string: resturantImage[0].imageUrl ?? ""))
            }
            else
            {
                cell.resturantImageCell.image = UIImage(named: "person")
            }
            cell.resturantName.text = "\(restaurant.firstName ?? "") \(restaurant.lastName ?? "")"
            cell.resturantAddress.text = restaurant.email
            cell.resturantContactNo.text = restaurant.phoneNumber
        }
        else
        {
            cell.resturantImageCell.layer.cornerRadius = 10
            let restaurant = self.arrObjResturants[indexPath.row]
            let resturantImage = restaurant.certificatesImages as! [CHDishImageModel]
            if resturantImage.count > 0 {
                cell.resturantImageCell.sd_setImage(with: URL(string: resturantImage[0].imageUrl ?? ""))
            }
            cell.resturantName.text = restaurant.firstName
            cell.resturantAddress.text = restaurant.address
            cell.resturantContactNo.text = restaurant.phoneNumber
        }
        
        // Configure cell with restaurant information
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if objCurrentUser.userType == "Resturant"
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CHChefProfileDetailViewController") as? CHChefProfileDetailViewController
            vc?.hidesBottomBarWhenPushed = true
            vc?.objChef = self.arrObjChef[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else
        {
            let obj = arrObjResturants[indexPath.row]
            let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Show in Map", style: .default, handler: { _ in
                self.showInMap(address: obj.address ?? "")
            }))
            alert.addAction(UIAlertAction(title: "Contact Resturant", style: .default, handler: { _ in
                self.contactResturant(objCurrentUser: self.objCurrentUser, objResturant: obj)
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
