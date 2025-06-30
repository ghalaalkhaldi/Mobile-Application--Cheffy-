

import UIKit
import Firebase

class CHEditProfileViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    // Variable to hold current user data
    var objCurrentUser = CHUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch user profile data and populate fields
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid ?? "") { array, isSuccessfull in
            self.objCurrentUser = array![0] as! CHUserModel
            self.txtFirstName.text = self.objCurrentUser.firstName
            self.txtAddress.text = self.objCurrentUser.address
            self.txtLastName.text = self.objCurrentUser.lastName
            self.txtPhoneNo.text = self.objCurrentUser.phoneNumber
            self.btnSave.layer.cornerRadius = 10 // Round save button
        }
    }
    
    // Back button action
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Save button action
    @IBAction func btnSave_Pressed(_ sender: Any) {
        // Edit user profile with updated data
        CHProfileAPIManager().editUser(firstName: txtFirstName.text ?? "", lastName: txtLastName.text ?? "", phoneNumber: txtPhoneNo.text ?? "", address: txtAddress.text ?? "") { message, isSuccessfull in
            if isSuccessfull {
                // Navigate back to previous screen and show success message
                self.navigationController?.popViewController(animated: true)
                CHUtilityFunctions().showAlert(message: "Profile Updated", from: self)
            } else {
                // Show error message if profile update fails
                CHUtilityFunctions().showAlert(message: message ?? "", from: self)
            }
        }
    }
    
}
