

import UIKit
import Firebase
import ChatSDK
import ChatSDKFirebase


class CHCategoriesRestaurantViewController: UIViewController {
    
    @IBOutlet weak var tblRestaurant: UITableView!
    @IBOutlet weak var lblSelectedCate: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    
    var selectedCategory = ""
    var isChatOpenAlready = false
    var arrRest : [CHUserModel] = []
    var arrRestTemp : [CHUserModel] = []
    var objCurrentUser = CHUserModel()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblSelectedCate.text = selectedCategory
        self.arrRest = []
        self.arrRestTemp = []
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid) { array, isSuccessfull in
            if isSuccessfull
            {
                self.objCurrentUser = array![0] as! CHUserModel
                CHProfileAPIManager().getAllUsers { array, isSuccessfull in
                    if isSuccessfull
                    {
                        self.arrRestTemp = array as! [CHUserModel]
                        //                if self.arrRestTemp.count > 0
                        //                {
                        for i in self.arrRestTemp
                        {
                            if i.userType == "Resturant"
                            {
                                if i.category == self.selectedCategory
                                {
                                    self.arrRest.append(i)
                                }
                            }
                        }
                        if self.arrRest.count > 0
                        {
                            self.tblRestaurant.reloadData()
                        }
                        else
                        {
                            self.arrRest = []
                            self.tblRestaurant.reloadData()
                            CHUtilityFunctions().showAlert(message: "No Restaurant found under selected Cuisine.", from: self)
                        }
                    }
                    else
                    {
                        
                    }
                }
            }
            else
            {
                
            }
        }

    }
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //This line declares a function named showInMap.
    //It takes a single argument, address, which is
    //a string representing the address you want to show on the map.
    func showInMap(address:String)
    {
        
        // Format the address to be URL-friendly
        //Addresses often contain spaces, special characters, and other elements that aren't directly usable in URLs.
        //This line takes the input address and converts it into a format suitable for use within a URL.
        //The addingPercentEncoding method replaces problematic characters with their URL-safe equivalents (e.g., spaces become %20).
        let formattedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Google Maps URL scheme
        //
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
extension CHCategoriesRestaurantViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHCategoriesTableViewCell", for: indexPath) as! CHCategoriesTableViewCell
        
        // Configure cell with dish information
        let dish = arrRest[indexPath.row]
        let dishImages = dish.certificatesImages as! [CHDishImageModel]
        cell.categoriesDishesName.text = dish.firstName
        cell.categoriesImageViewCell.sd_setImage(with: URL(string: dishImages[0].imageUrl ?? ""), placeholderImage: UIImage(named: ""))
        cell.categoriesImageViewCell.layer.cornerRadius = 10
        cell.categoriesDishesPriceCell.text = dish.address ?? ""
        cell.categoriesDishesPostedByCell.text  = dish.phoneNumber ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrRest[indexPath.row]
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
