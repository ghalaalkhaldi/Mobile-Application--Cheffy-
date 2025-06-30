
import UIKit
import Firebase

class CHMyChefsViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblChefs: UITableView!
    @IBOutlet weak var viewBody: UIView!
    
    
    var objCurrentUser: CHUserModel = CHUserModel() //A CHUserModel object to store the profile data of the currently logged-in user.
    var arrMyChefs :[CHDishBuyModel] = [] //An array to hold CHDishBuyModel objects representing dishes the user has bought, including information about the chefs who made them
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.arrMyChefs = [] //Empties the arrMyChefs array to start fresh.
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid) { array, isSuccessfull in // Fetches the current user's profile using CHProfileAPIManager.getUserProfile().
            if isSuccessfull
            {
                self.objCurrentUser = array?[0] as! CHUserModel //Sets the objCurrentUser to the fetched user data.
                self.arrMyChefs = self.objCurrentUser.arrDishBuy as! [CHDishBuyModel] //Extracts the arrDishBuy array from objCurrentUser and assigns it to arrMyChefs.
                if self.arrMyChefs.count > 0 //If arrMyChefs is not empty
                {
                    self.tblChefs.reloadData() //it reloads the table view to display the chef data.
                }
                else
                {
                    self.arrMyChefs = []
                    self.tblChefs.reloadData()
                    CHUtilityFunctions().showAlert(message: "No chef has worked for you before .", from: self)
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
    

}
extension CHMyChefsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMyChefs.count //Returns the number of rows (chefs) to display in the table view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configures each table view cell with the chef's information
        //(name, email, phone number, category, and profile picture).
        //It also formats and displays the timestamp of when the dish was bought.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHMyChefTableViewCell", for: indexPath) as! CHMyChefTableViewCell
        let obj = self.arrMyChefs[indexPath.row]
        cell.imgDish.sd_setImage(with: URL(string: obj.chefImage ?? ""), placeholderImage: UIImage(named: "person"))
        cell.lblChefName.text = obj.cheifName ?? ""
        cell.lblChefEmail.text = obj.chefEmail ?? ""
        cell.lblChefCategory.text = obj.chefCategory ?? ""
        if let timestampMillis = obj.timestamp {
            // Convert milliseconds to seconds
            let timestampSeconds = TimeInterval(timestampMillis) / 1000.0
            let date = Date(timeIntervalSince1970: timestampSeconds)
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/YY" // This is the format you want to display

            cell.lblChefTimestamp.text = outputFormatter.string(from: date) // Set message timestamp
        } else {
            // Handle the case where the timestamp is nil
            cell.lblChefTimestamp.text = "No Date"
        }


        cell.lblChefPhoneNo.text = obj.chefPhoneNo ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Sets a fixed height (175.0 points) for each row in the table view.
        return 175.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //Handles the action when a row (chef) is selected
        //Instantiates the CHChefProfileDetailViewController.
        let vc = storyboard?.instantiateViewController(withIdentifier: "CHChefProfileDetailViewController") as? CHChefProfileDetailViewController
        vc?.hidesBottomBarWhenPushed = true
        let temp = self.arrMyChefs[indexPath.row]
        vc?.entityId = temp.chefId ?? "" //Sets the entityId property of the detail view controller to the selected chef's ID.
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
