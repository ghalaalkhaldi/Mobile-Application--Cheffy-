

import UIKit
import iOSDropDown
import SVProgressHUD
import Firebase

class SignupRestaurantViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UICollectionViewDelegate, UINavigationControllerDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var txtCategory: DropDown!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtRestaurantName: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    
    var imagePicker = UIImagePickerController()
    var userType = ""
    let categories = ["Arabic", "Chinese", "French", "Indian", "Japanese", "Lebanese", "Mexican", "Pakistani", "Spanish", "Thai"]
    private var selectedImages: [UIImage] = []
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
    
        imagePicker.delegate = self
        self.txtPassword.isSecureTextEntry = true // Hide password characters
        self.txtPassword.delegate = self // Set delegate for password field
        self.btnSignUp.layer.cornerRadius = 10
        self.collectionViewImages.delegate = self
        self.collectionViewImages.dataSource = self
        self.dropDownUISetup(txtDropDown: self.txtCategory, defaultString: "Arabic", optionArray: self.categories, type: "")
    }
    
    @IBAction func btnSignUp_Pressed(_ sender: Any)
    {
        // Validate password format
        if self.validatePassword(self.txtPassword.text ?? "") == true {
            // Validate other input fields
            if txtEmail.text?.isEmailValid == true && txtPhoneNo.text?.isEmpty == false && txtAddress.text?.isEmpty == false && txtRestaurantName.text?.isEmpty == false && self.txtCategory.text?.isEmpty == false {
                // Show loading indicator
                SVProgressHUD.show()
                
                // Create user account in Firebase
                CHAccountsAPIManager().createResturant(resturantName: self.txtRestaurantName.text ?? "", email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", userType: "Resturant", phoneNumber: self.txtPhoneNo.text ?? "", address: self.txtAddress.text ?? "", selectedImages: self.selectedImages, category: self.txtCategory.text ?? "Arabic", completionBlock: { message, isSuccessfull in
                    if isSuccessfull
                    {
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
                    }else
                    {
                        SVProgressHUD.dismiss()
                        CHUtilityFunctions().showAlert(message: message ?? "ERROR", from: self)
                    }
                    
                    
                    
                })
                
            }
            else
            {
                CHUtilityFunctions().showAlert(message: "Fill all fields in order to signup.", from: self)
            }
        }
        else
        {
            CHUtilityFunctions().showAlert(message: "Password is not valid. Password must contain one capital letter, one special character, and password length should be at least 8 characters.", from: self)
        }
    }
    @IBAction func btnAddImage_Pressed(_ sender: Any)
    {
        self.showImageSelectionOptions()
    }
            
          
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
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
    
    func dropDownUISetup(txtDropDown: DropDown, defaultString:String, optionArray:[String] , type: String )
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
            self.collectionViewImages.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle cancel action of image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
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
        return CGSize(width: 100.0 , height: 100.0)
    }
    
    // Function to handle delete button press on image cell
    @objc func btnDelete_pressed(sender : UIButton) {
        let i : Int = sender.tag
        self.selectedImages.remove(at: i)
        collectionViewImages.reloadData()
    }
}
