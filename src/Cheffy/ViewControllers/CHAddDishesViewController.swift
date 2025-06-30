

import Foundation
import UIKit
import iOSDropDown // Import the DropDown library
import SDWebImage // Import the SDWebImage library for image loading
import Firebase // Import Firebase for authentication
import SVProgressHUD
class CHAddDishesViewController: UIViewController {
    
    // Outlets for UI elements
    @IBOutlet weak var collectionViewResturantImage: UICollectionView!
    @IBOutlet weak var btnResturantAddImage: UIButton!
    @IBOutlet weak var btnResturant: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblAddDishes: UILabel!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var viewCollectionView: UIView!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtCategory: DropDown! // DropDown view for selecting categories
    @IBOutlet weak var addNewDishesCollectionView: UICollectionView!
    @IBOutlet weak var viewAddResturant: UIView!
    @IBOutlet weak var viewAddDishes: UIView!
    @IBOutlet weak var txtResturantTitle: UITextField!
    @IBOutlet weak var txtResturantAddress: UITextField!
    @IBOutlet weak var txtResturantEmail: UITextField!
    @IBOutlet weak var txtResturantPhoneNumber: UITextField!
    
    // Model object to store current user information
    var objCurrentUser = CHUserModel()
    
    // Array to store selected images
    private var selectedImages: [UIImage] = []
    
    // Image picker controller for selecting images
    var imagePicker = UIImagePickerController()
    
    // Array of categories
    let categories = ["Arabic", "Chinese", "French", "Indian", "Japanese", "Lebanese", "Mexican", "Pakistani", "Spanish", "Thai"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up image picker
        imagePicker.delegate = self
        // Set up UI elements
        self.btnCreate.layer.cornerRadius = 15
        self.dropDownUISetup(txtDropDown: self.txtCategory, defaultString: "Arabic", optionArray: self.categories, type: "")
        self.txtDescription.layer.cornerRadius = 10
        self.viewCollectionView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch current user profile
        let userId = Auth.auth().currentUser?.uid
        CHProfileAPIManager().getUserProfile(userId: userId) { array, isSuccessfull in
            if isSuccessfull {
                self.objCurrentUser = array![0] as! CHUserModel
                // Check user type and adjust UI accordingly
                if self.objCurrentUser.userType == "Chef" {
                    self.lblAddDishes.text = "Add Dishes"
                    self.viewAddDishes.isHidden = false
                    self.viewAddResturant.isHidden = true
                    self.txtEmail.text = self.objCurrentUser.email
                    self.txtPhoneNo.text = self.objCurrentUser.phoneNumber
                    self.txtAddress.text = self.objCurrentUser.address
                    self.scrollView.frame.size.height = 900.0
                } else {
                    self.lblAddDishes.text = "Add Resturants"
                    self.viewAddDishes.isHidden = true
                    self.viewAddResturant.isHidden = false
                    self.scrollView.frame.size.height = 620.0
                    self.btnResturant.layer.cornerRadius = 10
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnResturant_Pressed(_ sender: Any) {
        // Check if all required fields are filled
        if txtResturantTitle.text != "", txtResturantEmail.text != "", txtResturantPhoneNumber.text != "", txtResturantAddress.text != "", selectedImages.count > 0 {
            // Create a new restaurant
            CHResturantAPIManager().createResturants(title: self.txtResturantTitle.text, selectedImages: selectedImages, email: self.txtResturantEmail.text, phoneNo: self.txtResturantPhoneNumber.text ?? "", address: self.txtResturantAddress.text ?? "", id: UUID(), postedByName: "\(self.objCurrentUser.firstName ?? "") \(self.objCurrentUser.lastName ?? "") ") { message, isSuccessfull in
                if isSuccessfull {
                    // Show success message and reset fields
                    CHUtilityFunctions().showAlert(message: "New Resturant Added Successfully.", from: self)
                    self.resetResturantFields()
                }
            }
        } else {
            // Show alert if required fields are missing
            CHUtilityFunctions().showAlert(message: "Kindly Fill Complete Details.", from: self)
        }
    }
    
    @IBAction func btnResturantAddImage_Pressed(_ sender: Any) {
        // Show options to select image from camera or gallery
        showImageSelectionOptions()
    }
    
    @IBAction func btnAddImage_Pressed(_ sender: Any) {
        // Show options to select image from camera or gallery
        showImageSelectionOptions()
    }
    
    @IBAction func btnCreate_Pressed(_ sender: Any) {
        // Check if all required fields are filled
        SVProgressHUD.show()
        if txtTitle.text != "", txtCategory.text != "", txtDescription.text != "" , txtPrice.text != "", txtEmail.text != "", txtPhoneNo.text != "", txtAddress.text != "", selectedImages.count > 0 {
            // Create a new dish
            CHDishesAPIManager().createDishes(title: self.txtTitle.text, selectedImages: selectedImages ,description: self.txtDescription.text, category: self.txtCategory.text, price: self.txtPrice.text, email: self.txtEmail.text ?? "", phoneNo: self.txtPhoneNo.text ?? "", address: self.txtAddress.text ?? "", id: UUID(), postedByName: "\(self.objCurrentUser.firstName ?? "") \(self.objCurrentUser.lastName ?? "") ") { message, isSuccessfull in
                if isSuccessfull{
                    // Show success message and reset fields
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        SVProgressHUD.dismiss()
                        CHUtilityFunctions().showAlert(message: "New Dish Added Successfully.", from: self)
                        self.resetDishFields()
                    }
                } 
                else
                {
                    SVProgressHUD.dismiss()
                    
                    // Show alert if dish creation fails
                    CHUtilityFunctions().showAlert(message: "Dishes not posted. Try again later.", from: self)
                }
            }
        } else {
            // Show alert if required fields are missing
            CHUtilityFunctions().showAlert(message: "Kindly Fill Complete Details.", from: self)
        }
    }
    
    // MARK: - Helper Methods
    
    // Function to set up DropDown UI
    func dropDownUISetup(txtDropDown: DropDown, defaultString:String, optionArray:[String] , type: String ) {
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
    
    // Function to show image selection options
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
    
    // Function to reset restaurant fields
    func resetResturantFields() {
        self.txtResturantTitle.text = ""
        self.txtResturantEmail.text = ""
        self.txtResturantAddress.text = ""
        self.txtResturantPhoneNumber.text = ""
        self.selectedImages = []
        self.collectionViewResturantImage.reloadData()
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
    
    // Function to reset dish fields
    func resetDishFields() {
        self.txtTitle.text = ""
        self.txtEmail.text = ""
        self.txtCategory.text = ""
        self.txtPrice.text = ""
        self.txtAddress.text = ""
        self.txtDescription.text = ""
        self.txtPhoneNo.text = ""
        self.selectedImages = []
        self.addNewDishesCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension CHAddDishesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CHAddDishesCollectionViewCell", for: indexPath) as! CHAddDishesCollectionViewCell
        cell.addNewDishesImageCell.image = self.selectedImages[indexPath.row]
        cell.btnDeleteImage.addTarget(self, action: #selector(btnDelete_pressed(sender:)), for:.touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0 , height: 80.0)
    }
    
    // Function to handle delete button press on image cell
    @objc func btnDelete_pressed(sender : UIButton) {
        let i : Int = sender.tag
        self.selectedImages.remove(at: i)
        addNewDishesCollectionView.reloadData()
        collectionViewResturantImage.reloadData()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension CHAddDishesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Function to handle image selection from camera or gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            // Add selected image to the array
            self.selectedImages.append(editedImage)
            self.dismiss(animated: true, completion: nil)
            self.addNewDishesCollectionView.reloadData()
            self.collectionViewResturantImage.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Function to handle cancel action of image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

