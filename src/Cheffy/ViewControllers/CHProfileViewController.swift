

import UIKit
import Firebase // Import Firebase for authentication
import SDWebImage // Import SDWebImage for image loading
import ChatSDK // Import ChatSDK for chat functionality

// View controller for user profile
class CHProfileViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var btnMyOrderHeight: NSLayoutConstraint!
    @IBOutlet weak var btnMyOrders: UIButton!
    @IBOutlet weak var btnChangeProfilePic: UIButton!
    @IBOutlet weak var btnlogOut: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var ImgProfile: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewMian: UIView!
    
    // Variables
    var objCurrentUser = CHUserModel() // Current user object
    var image: UIImage? // Variable to hold selected image
    var imagePicker = UIImagePickerController() // Image picker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self // Set image picker delegate
        // Fetch user profile data
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid ?? "") { array, isSuccessfull in
            if isSuccessfull
            {
                self.objCurrentUser = array![0] as! CHUserModel
                print(self.objCurrentUser.firstName ?? "")
                print(self.objCurrentUser.lastName ?? "")
                // Load profile image
                self.ImgProfile.sd_setImage(with: URL(string: self.objCurrentUser.profilePic ?? ""), placeholderImage: UIImage(named: "person"))
                
                self.ImgProfile.layer.cornerRadius = self.ImgProfile.frame.size.width / 2 // Round profile image
                //                if self.objCurrentUser.userType == "Chef"
                //                {
                //                    self.btnSettings.setTitle("My Dishes", for: .normal)
                //                    self.btnMyOrderHeight.constant = 0
                //                    self.btnMyOrders.isHidden = true
                //                }
                //                else
                //                {
                //                    self.btnSettings.setTitle("My Chefs", for: .normal)
                //                    self.btnMyOrderHeight.constant = 50
                //                    self.btnMyOrders.isHidden = false
                //                }
            }
            else
            {
                
            }
        }
        // Round buttons
        self.btnlogOut.layer.cornerRadius = 15
        self.btnEditProfile.layer.cornerRadius = 15
        self.btnMyOrders.layer.cornerRadius = 15
        self.btnSettings.layer.cornerRadius = 15
        self.btnNotification.layer.cornerRadius = 15
    }
    
    // Button actions
    
    // Edit profile button action
    @IBAction func btnMyOrders_Pressed(_ sender: Any) {
        
        if self.objCurrentUser.userType == "Chef"
        {
            
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHMyOrdersChefViewController") as? CHMyOrdersChefViewController)!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHMyOrdersViewController") as? CHMyOrdersViewController)!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    @IBAction func btnEditProfile_pressed(_ sender: Any) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "CHEditProfileViewController") as? CHEditProfileViewController)!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Logout button action
    @IBAction func btnLogout_pressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are You Sure ?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes,Log Out", style: .default, handler: { _ in
            BChatSDK.auth().logout() // Logout from chat
            self.logoutUser() // Logout user from Firebase
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Logout user from Firebase
    func logoutUser() {
        let auth = Auth.auth()
        do {
            try auth.signOut() // Sign out
            let vc = (storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController") as? LoginPageViewController)!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        } catch let signOutError {
            let errorAlert = UIAlertController(title: "Error", message: "\(signOutError)", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    // Settings button action
    @IBAction func btnSettings_pressed(_ sender: Any) {
        if self.objCurrentUser.userType == "Chef"
        {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHMyDIshesViewController") as? CHMyDIshesViewController)!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHMyChefsViewController") as? CHMyChefsViewController)!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // Notification button action
    @IBAction func btnNotification_pressed(_ sender: Any) {
        // Handle notification button action
    }
    
    // Change profile picture button action
    @IBAction func btnChangeProfilePic_Pressed(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera() // Open camera
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery() // Open gallery
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open gallery to select image
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Open camera to capture image
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Update profile picture
    func updateProfilePicture() {
        guard let data = self.image?.jpegData(compressionQuality: 0.5) else { return }
        let userID = Auth.auth().currentUser?.uid
        CHProfileAPIManager().updateUserProfilePicture(userId: userID,imgData: data, completionBlock: {(message,isSuccess) in
            if(isSuccess!) {
                CHUtilityFunctions().showAlert(message: "Profile picture updated successfully", from: self)
            } else {
                CHUtilityFunctions().showAlert(message: "Error updating profile picture", from: self)
            }
        })
    }
    
    // Image picker delegate methods
    
    // Called when image is picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.image = pickedImage
            self.ImgProfile.image = image
            self.dismiss(animated: true, completion: nil)
            updateProfilePicture() // Update profile picture
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Called when image picking is cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
