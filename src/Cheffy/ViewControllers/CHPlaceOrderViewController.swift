import UIKit
import Firebase
import SVProgressHUD
import FirebaseDatabase

// ViewController to handle placing orders
class CHPlaceOrderViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Outlets connected to storyboard
    @IBOutlet weak var btnCloseCardView: UIButton!
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCVC: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var viewCardDetails: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var lblChefName: UILabel!
    @IBOutlet weak var imgChefProfilePic: UIImageView!
    @IBOutlet weak var txtDishDescription: UITextView!
    @IBOutlet weak var lblDishPrice: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewBody: UIView!
    
    // Firebase reference
    var ref: DatabaseReference! //This establishes a reference to a Firebase Realtime Database, which is probably used to store order details and other data.
    
    // Variables to hold data models
    var objDish = CHDishesModel()
    var objCheif = CHUserModel()
    var isFromOrder = false
    
    // ViewDidLoad - initial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection view data source and delegate setup
        collectionView.dataSource = self
        
        // UI customization
        self.viewCardDetails.layer.cornerRadius = 20
        self.btnPayNow.layer.cornerRadius = 15
        self.viewCardDetails.layer.borderWidth = 2.0
        self.viewCardDetails.layer.borderColor = CGColor(red: 114/255, green: 25/255, blue: 19/255, alpha: 1.0)
        self.viewCardDetails.isHidden = true
        
        // Text field delegates
        self.txtCVC.delegate = self
        self.txtCardNumber.delegate = self
        self.txtExpiryDate.delegate = self
        
        // Firebase setup
        ref = Database.database().reference()
        ref.keepSynced(true)
    }
    
    // ViewWillAppear - setting up the UI elements with model data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display dish and chef details
        self.lblDishPrice.text = "Price: \(objDish.price ?? "")"
        self.lblDishName.text = "Dish Name: \(objDish.title ?? "")"
        self.lblChefName.text = objDish.postedByName ?? ""
        self.txtDishDescription.text = objDish.dishDescription
        self.imgChefProfilePic.sd_setImage(with: URL(string: self.objCheif.profilePic ?? ""), placeholderImage: UIImage(named: "person"))
        self.imgChefProfilePic.layer.cornerRadius = self.imgChefProfilePic.frame.size.width / 2
        
        // Configure Accept and Reject buttons based on the context
        if isFromOrder {
            self.btnAccept.isHidden = true
            self.btnReject.isHidden = true
        } else {
            self.btnAccept.isHidden = false
            self.btnReject.isHidden = false
        }
        
        // Round corner for Accept and Reject buttons
        self.btnAccept.layer.cornerRadius = 15
        self.btnReject.layer.cornerRadius = 15
    }
    
    // Action for closing the card view
    @IBAction func btnCloseCardView_Pressed(_ sender: Any) {
        self.viewCardDetails.isHidden = true
        CHUtilityFunctions().removeBlurEffect(viewToRemoveBlur: self.viewBody)
        CHUtilityFunctions().removeBlurEffect(viewToRemoveBlur: self.viewHeader)
    }
    
    // Action for the Pay Now button
    @IBAction func btnPayNow_Pressed(_ sender: Any) {
        if isValidInput() {
            SVProgressHUD.show(withStatus: "Purchasing")
            let temp = self.objDish.selectedImages[0] as! CHDishImageModel
            
            // Simulate a purchase with a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                CHDishesAPIManager().buyDish(userId: Auth.auth().currentUser?.uid ?? "", dishName: self.objDish.title ?? "", dishId: self.objDish.id ?? "", dishCategory: self.objDish.category ?? "", dishPrice: self.objDish.price ?? "", dishImage: temp.imageUrl ?? "", cheffName: self.objDish.postedByName ?? "", chefId: self.objDish.postedBy ?? "", chefCategory: self.objCheif.category ?? "", chefPhoneNo: self.objCheif.phoneNumber ?? "", chefEmail: self.objCheif.email ?? "", chefImage: self.objCheif.profilePic ?? "") { message, isSuccessfull in
                    if isSuccessfull {
                        CHUtilityFunctions().removeBlurEffect(viewToRemoveBlur: self.viewHeader)
                        CHUtilityFunctions().removeBlurEffect(viewToRemoveBlur: self.viewBody)
                        self.viewCardDetails.isHidden = true
                        SVProgressHUD.dismiss()
                        CHUtilityFunctions().showAlert(message: "Order Placed Successfully.", from: self)
                    }
                }
            }
        }
    }
    
    // Action for the Reject button
    @IBAction func btnReject_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Action for the Accept button
    @IBAction func btnAccept_pressed(_ sender: Any) {
        self.viewCardDetails.isHidden = false
        CHUtilityFunctions().blurEffect(viewToBlur: self.viewBody)
        CHUtilityFunctions().blurEffect(viewToBlur: self.viewHeader)
    }
    
    // Action for the Back button
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Function to validate input fields
    func isValidInput() -> Bool {
        let txtDate = self.txtExpiryDate.text!
        let month = txtDate.prefix(2)
        let year = txtDate.suffix(2)
        let whitespace = CharacterSet.whitespacesAndNewlines
        
        // Check for whitespace and valid month/year values
        let rangeCVC: NSRange = (txtCVC.text! as NSString).rangeOfCharacter(from: whitespace)
        let rangeExpMonth: NSRange = (month as NSString).rangeOfCharacter(from: whitespace)
        let rangeExpYear: NSRange = (year as NSString).rangeOfCharacter(from: whitespace)
        
        if Int(month) ?? 3 > 12 {
            self.showAlertView(title: "", message: "Please enter valid exp month")
            return false
        } else if Int(year) ?? 12 < 18 {
            self.showAlertView(title: "", message: "Please enter valid exp year number")
            return false
        } else if rangeCVC.location != NSNotFound {
            self.showAlertView(title: "", message: "Please enter valid CVC number number")
            return false
        } else if rangeExpMonth.location != NSNotFound {
            self.showAlertView(title: "", message: "Please enter valid exp month")
            return false
        } else if rangeExpYear.location != NSNotFound {
            self.showAlertView(title: "", message: "Please enter valid exp year")
            return false
        } else {
            return true
        }
    }
    
    // Function to show alert messages
    func showAlertView(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true)
    }
    
    // Text field delegate function to handle character changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtCardNumber { // Check if the modified textField is the card number field
            // Create a set of characters that are NOT numbers or "." (the decimal point)
            let nonNumberSet = CharacterSet(charactersIn: "0123456789.").inverted
            
            // Formatting card number with spaces every 4 digits
            if (textField.text?.count ?? 0) == 4 && string.count != 0 {
                // If there are already 4 digits and the user is adding more, insert a space
                textField.text = "\(textField.text ?? "")\(" ")"
            } else if (textField.text?.count ?? 0) == 9 && string.count != 0 {
                textField.text = "\(textField.text ?? "")\(" ")"
            } else if (textField.text?.count ?? 0) == 14 && string.count != 0 {
                textField.text = "\(textField.text ?? "")\(" ")"
            }
            
            // Allow only numbers and space formatting
            if range.length == 1 { // If the user is deleting a character, allow it
                return true
            } else if (textField.text?.count ?? 0) < 19 {
                // If the total length is less than 19 (max card number length with spaces),
                // Check if the entered string ONLY contains numbers (after removing any non-numeric characters)
                return string.trimmingCharacters(in: nonNumberSet).count > 0
            } else {
                return false //Don't allow further input if max length is reached
            }
        } else if textField == txtCVC { // Check if the modified textField is the CVC field
            let nonNumberSet = CharacterSet(charactersIn: "0123456789.").inverted
            
            // Allow only numbers and limit to 3 characters
            if range.length == 1 {
                return true
            } else if (textField.text?.count ?? 0) < 3 {
                return string.trimmingCharacters(in: nonNumberSet).count > 0
            } else {
                return false
            }
        } else if textField == txtExpiryDate { // Check if the modified textField is the expiry date field
            let nonNumberSet = CharacterSet(charactersIn: "0123456789.").inverted
            
            // Formatting expiry date with a slash after 2 digits
            if (textField.text?.count ?? 0) == 2 && string.count != 0 {
                textField.text = "\(textField.text ?? "")\("/")"
            }
            
            // Allow only numbers and slash formatting
            if range.length == 1 {
                return true
            } else if (textField.text?.count ?? 0) < 5 { // Max length of MM/YY is 5
                return string.trimmingCharacters(in: nonNumberSet).count > 0
            } else {
                return false
            }
        } else { // For any other textField, allow input without restrictions
            return true
        }
    }
    
    // Collection view data source method to set number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objDish.selectedImages.count
    }

    // Collection view data source method to configure cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishDetailViewControllerCollectionViewCell", for: indexPath) as! DishDetailViewControllerCollectionViewCell
        let objImage = self.objDish.selectedImages as! [CHDishImageModel]
        let temp = objImage[indexPath.item]
        cell.DishDetailControllerCellImage.sd_setImage(with: URL(string: temp.imageUrl ?? ""))
        cell.DishDetailControllerCellImage.layer.cornerRadius = 10
        return cell
    }

    // Collection view delegate flow layout method to set item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameSize = collectionView.frame.size
        return CGSize(width: (frameSize.width / 1.8) - 5, height: frameSize.height)
    }

    // Collection view delegate flow layout method to set minimum line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    // Collection view delegate flow layout method to set minimum interitem spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    // Collection view delegate flow layout method to set section insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
