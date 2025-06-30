import UIKit
import SVProgressHUD
import iOSDropDown //A third-party library for creating customizable dropdown menus.
import Firebase

class SignupPageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // Outlets for UI elements
    @IBOutlet weak var txtChefDescription: UITextView!
    @IBOutlet weak var collectionViewCertificates: UICollectionView!
    @IBOutlet weak var btnUploadCertificates: UIButton!
    @IBOutlet weak var txtCategory: DropDown!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    // Variable to track user type (Chef)
    var imagePicker = UIImagePickerController() //Used for selecting images from the camera or photo library.
    var userType = "" //Stores the type of user (in this case, it would be "Chef").
    //An array of available categories for chefs to choose from.
    let categories = ["Arabic", "Chinese", "French", "Indian", "Japanese", "Lebanese", "Mexican", "Pakistani", "Spanish", "Thai"]
    private var selectedImages: [UIImage] = [] //An array to hold the images selected by the user.
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        // Customize UI elements
        imagePicker.delegate = self //Sets up the image picker's delegate.
        self.passwordTextField.isSecureTextEntry = true // Hide password characters
        self.passwordTextField.delegate = self // Set delegate for password field
        self.btnSignup.layer.cornerRadius = 10
        self.dropDownUISetup(txtDropDown: self.txtCategory, defaultString: "Arabic", optionArray: self.categories, type: "")
    }
    
    // Action when back button is pressed
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUploadCertificates_Pressed(_ sender: Any) {
        showImageSelectionOptions()
    }
    // Action when signup button is pressed
    @IBAction func btnSignup_pressed(_ sender: Any) {
        // Validate password format
        if self.validatePassword(self.passwordTextField.text ?? "") == true {
            // Validate other input fields
            if emailTextField.text?.isEmailValid == true && txtPhoneNumber.text?.isEmpty == false && txtAddress.text?.isEmpty == false && firstNameTextField.text?.isEmpty == false && lastNameTextField.text?.isEmpty == false && self.txtCategory.text?.isEmpty == false && self.txtChefDescription.text.isEmpty == false {
                // Show loading indicator
                SVProgressHUD.show()
                
                // Create user account in Firebase
                CHAccountsAPIManager().createChef(firstName: self.firstNameTextField.text, lastName: self.lastNameTextField.text, email: self.emailTextField.text, password: self.passwordTextField.text, userType: self.userType, phoneNumber: self.txtPhoneNumber.text ?? "", address: self.txtAddress.text ?? "",chefDescription: self.txtChefDescription.text,selectedImages: self.selectedImages,category: self.txtCategory.text ?? "") { message, isSuccessfull in
                    if isSuccessfull {
                        // Send email verification
                        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                            if error == nil {
                                // Show success alert and navigate to login page
                                self.showSuccessAlert()
                            } else {
                                // Show error message if sending verification email fails
                                SVProgressHUD.dismiss()
                                CHUtilityFunctions().showAlert(message: "\(error!)", from: self)
                                print(error!)
                            }
                        })
                    } else {
                        // Show error message if signup fails
                        SVProgressHUD.dismiss()
                        CHUtilityFunctions().showAlert(message: message ?? "ERROR", from: self)
                    }
                }
            } else {
                // Show alert for incomplete fields
                CHUtilityFunctions().showAlert(message: "Fill all fields in order to signup.", from: self)
            }
        } else {
            // Show alert for invalid password format
            CHUtilityFunctions().showAlert(message: "Password is not valid. Password must contain one capital letter, one special character, and password length should be at least 8 characters.", from: self)
        }
    }
    
    func dropDownUISetup(txtDropDown: DropDown, defaultString:String, optionArray:[String] , type: String )  //Configures the appearance and behavior of the dropdown menu.
    {
        txtDropDown.text = defaultString
        txtDropDown.isSearchEnable = false
        txtDropDown.arrowSize = 14
        txtDropDown.sizeToFit()
        txtDropDown.arrowColor = OEColorConstants.colors.textTertiaryColor
        txtDropDown.checkMarkEnabled = false
        txtDropDown.textColor = OEColorConstants.colors.textTertiaryColor
        txtDropDown.alpha = 0.7
        txtDropDown.selectedRowColor = OEColorConstants.colors.viewPrimaryColor
        txtDropDown.font = UIFont().setFontName(name: "regular", size: 12)
        txtDropDown.adjustsFontSizeToFitWidth = false
        txtDropDown.optionArray = optionArray
        txtDropDown.selectedIndex = optionArray.firstIndex(of: defaultString)
        txtDropDown.didSelect{(selectedText , index ,id) in
            self.txtCategory.text = selectedText
        }
    }
    func showImageSelectionOptions() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // Function to open Gallery
    func openGallery()
      {
          if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary))
          {
              imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
              imagePicker.allowsEditing = true
              self.present(imagePicker, animated: true, completion: nil)
          }
          else
          {
              let alert  = UIAlertController(title: "Warning", message: "You don't have gallery", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
      }
      
    // Function to open Camera
      func openCamera()
      {
          if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
          {
              imagePicker.sourceType = UIImagePickerController.SourceType.camera
              imagePicker.allowsEditing = true
              self.present(imagePicker, animated: true, completion: nil)
          }
          else
          {
              let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
      }
    
    // Function to handle image selection from camera or gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            // Add selected image to the array
            self.selectedImages.append(editedImage)
            self.dismiss(animated: true, completion: nil)
            self.collectionViewCertificates.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle cancel action of image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension String {
    var isEmailValid : Bool {
        let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", email)
        return emailTest.evaluate(with: self)
    }
}

extension SignupPageViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Function to validate the password format
    func validatePassword(_ password: String) -> Bool {
        // Define a regular expression pattern to enforce the requirements
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // Function to show a success alert after signup
    func showSuccessAlert() 
    {
        SVProgressHUD.dismiss()
        let dialogMessage = UIAlertController(title: "Success", message: "Email verification has been sent. Kindly verify your email in order to sign in.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
extension SignupPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CHAddDishesCollectionViewCell", for: indexPath) as! CHAddDishesCollectionViewCell
        cell.addNewDishesImageCell.image = self.selectedImages[indexPath.row]
        cell.btnDeleteImage.addTarget(self, action: #selector(btnDelete_pressed(sender:)), for:.touchUpInside)
        cell.addNewDishesImageCell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0 , height: 80.0)
    }
    
    // Function to handle delete button press on image cell
    @objc func btnDelete_pressed(sender : UIButton) {
        let i : Int = sender.tag
        self.selectedImages.remove(at: i)
        collectionViewCertificates.reloadData()
    }
}
