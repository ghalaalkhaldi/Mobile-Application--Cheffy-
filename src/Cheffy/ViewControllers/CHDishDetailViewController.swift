import UIKit
import ChatSDK
import Firebase
import ChatSDKFirebase
import SVProgressHUD
import FirebaseDatabase

class CHDishDetailViewController: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var btnBuyDish: UIButton!
    @IBOutlet weak var btnSubmitRating: UIButton!
    @IBOutlet weak var btnRateDish: UIButton!
    @IBOutlet weak var imgCreatedBy: UIImageView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var btnCloseRating: UIButton!
    @IBOutlet weak var imgDishRating: UIImageView!
    @IBOutlet weak var viewRatingInner: UIView!
    @IBOutlet weak var btnRating1: UIButton!
    @IBOutlet weak var btnRating2: UIButton!
    @IBOutlet weak var btnRating3: UIButton!
    @IBOutlet weak var btnRating4: UIButton!
    @IBOutlet weak var btnRating5: UIButton!
    
    // Variables
    var objDish = CHDishesModel()
    var objCheif = CHUserModel()
    var objSelfProfile = CHUserModel()
    var isChatOpenAlready = false
    var selectedRating = 0
    var ref: DatabaseReference!
    var isCurrentDishBought = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set collection view data source
        imgCollectionView.dataSource = self
        
        // Style the rating view
        self.viewRating.layer.cornerRadius = 20
        self.viewRatingInner.layer.cornerRadius = 20
        self.btnSubmitRating.layer.cornerRadius = 10
        self.imgDishRating.layer.cornerRadius = 15
        self.viewRating.layer.borderWidth = 2.0
        self.viewRating.layer.borderColor = CGColor(red: 114/255, green: 25/255, blue: 19/255, alpha: 1.0)
        
        // Initialize Firebase reference and sync
        ref = Database.database().reference()
        ref.keepSynced(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Populate dish details
        self.lblPrice.text = "Price : \(objDish.price ?? "")"
        self.lblDishName.text = objDish.title ?? ""
        self.lblCreatedBy.text = objDish.postedByName ?? ""
        self.txtDescription.text = objDish.dishDescription
        
        // Style buttons
        self.btnMessage.layer.cornerRadius = 15
        self.btnRateDish.layer.cornerRadius = 15
        self.btnBuyDish.layer.cornerRadius = 15
        
        // Fetch user profile data for chef and current user
        CHProfileAPIManager().getUserProfile(userId: self.objDish.postedBy) { array, isSuccessfull in
            if isSuccessfull {
                self.objCheif = array![0] as! CHUserModel
                self.imgCreatedBy.sd_setImage(with: URL(string: self.objCheif.profilePic ?? ""), placeholderImage: UIImage(named: "person"))
                self.imgCreatedBy.layer.cornerRadius = self.imgCreatedBy.frame.size.width / 2
                
                // Load dish images
                if self.objDish.selectedImages.count > 0 {
                    let objImage = self.objDish.selectedImages[0] as! CHDishImageModel
                    self.imgDishRating.sd_setImage(with: URL(string: objImage.imageUrl ?? ""), placeholderImage: UIImage(named: "person"))
                } else {
                    self.imgDishRating.image = UIImage(named: "Dishes")
                }
                
                // Fetch current user profile
                CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid) { array, isSuccessfull in
                    if isSuccessfull {
                        self.objSelfProfile = array![0] as! CHUserModel
                        if self.objSelfProfile.userType == "Chef"
                        {
                            self.btnBuyDish.isHidden = true
                        }
                        else
                        {
                            self.btnBuyDish.isHidden = false
                            let temp = self.objSelfProfile.arrDishBuy as! [CHDishBuyModel]
                        
                            for i in temp
                            {
                                if i.dishId == self.objDish.id ?? ""
                                {
                                    if i.status != "cancel"
                                    {
                                        self.isCurrentDishBought = true
                                    }
                                    break
                                }
                                
                            }
                            if self.isCurrentDishBought
                            {
                                self.btnBuyDish.setTitle("Already Bought", for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }

    // Message button action
    @IBAction func btnMessage_pressed(_ sender: UIButton) {
        // Set up users for chat
        let objOtherUser = self.objCheif
        let wrapper1: CCUserWrapper = CCUserWrapper.user(withEntityID: self.objSelfProfile.userId)
        wrapper1.metaOn()
        let user1: PUser = wrapper1.model()
        user1.setName(self.objSelfProfile.firstName)
        wrapper1.push()
        let wrapper2: CCUserWrapper = CCUserWrapper.user(withEntityID: objOtherUser.userId)
        wrapper2.metaOn()
        let user2: PUser = wrapper2.model()
        user2.setName(objOtherUser.firstName)
        wrapper2.push()
        let users: Array = [user1, user2]

        // Check if chat is already open
        let array = BChatSDK.core().threads(with: bThreadType1to1)
        let arrayThread = array as! [PThread]
        for i in arrayThread {
            if i.otherUser().entityID() == objOtherUser.userId {
                self.isChatOpenAlready = true
                i.otherUser().entityID()
                i.markRead()
                let chatViewController = BChatSDK.ui().chatViewController(with: i)
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
            BChatSDK.core().createThread(withUsers: users, threadCreated: {(error: Error?, thread: PThread?) in
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

    // Rating button actions
    @IBAction func btnRating1_Pressed(_ sender: Any) {
        self.selectedRating = 1
        self.btnRating1.setImage(UIImage(named: "SelectedRating1"), for: .normal)
        self.btnRating2.setImage(UIImage(named: "rating2"), for: .normal)
        self.btnRating3.setImage(UIImage(named: "rating3"), for: .normal)
        self.btnRating4.setImage(UIImage(named: "rating4"), for: .normal)
        self.btnRating5.setImage(UIImage(named: "rating5"), for: .normal)
    }

    @IBAction func btnRating2_Pressed(_ sender: Any) {
        self.selectedRating = 2
        self.btnRating2.setImage(UIImage(named: "SelectedRating2"), for: .normal)
        self.btnRating1.setImage(UIImage(named: "rating1"), for: .normal)
        self.btnRating3.setImage(UIImage(named: "rating3"), for: .normal)
        self.btnRating4.setImage(UIImage(named: "rating4"), for: .normal)
        self.btnRating5.setImage(UIImage(named: "rating5"), for: .normal)
    }

    @IBAction func btnRating3_Pressed(_ sender: Any) {
        self.selectedRating = 3
        self.btnRating3.setImage(UIImage(named: "SelectedRating3"), for: .normal)
        self.btnRating2.setImage(UIImage(named: "rating2"), for: .normal)
        self.btnRating1.setImage(UIImage(named: "rating1"), for: .normal)
        self.btnRating4.setImage(UIImage(named: "rating4"), for: .normal)
        self.btnRating5.setImage(UIImage(named: "rating5"), for: .normal)
    }

    @IBAction func btnRating4_Pressed(_ sender: Any) {
        self.selectedRating = 4
        self.btnRating4.setImage(UIImage(named: "SelectedRating4"), for: .normal)
        self.btnRating2.setImage(UIImage(named: "rating2"), for: .normal)
        self.btnRating3.setImage(UIImage(named: "rating3"), for: .normal)
        self.btnRating1.setImage(UIImage(named: "rating1"), for: .normal)
        self.btnRating5.setImage(UIImage(named: "rating5"), for: .normal)
    }

    @IBAction func btnRating5_Pressed(_ sender: Any) {
        self.selectedRating = 5
        self.btnRating5.setImage(UIImage(named: "SelectedRating5"), for: .normal)
        self.btnRating2.setImage(UIImage(named: "rating2"), for: .normal)
        self.btnRating3.setImage(UIImage(named: "rating3"), for: .normal)
        self.btnRating4.setImage(UIImage(named: "rating4"), for: .normal)
        self.btnRating1.setImage(UIImage(named: "rating1"), for: .normal)
    }

    // Close rating view
    @IBAction func btnCloseRating_Pressed(_ sender: Any) {
        CHUtilityFunctions().removeBlurEffect(viewToRemoveBlur: self.viewHeader)
        CHUtilityFunctions().removeBlurEffect(viewToRemoveBlur: self.viewBody)
        self.viewRating.isHidden = true
    }

    // Buy dish action
    @IBAction func btnBuyDish_pressed(_ sender: Any) {
        if isCurrentDishBought
        {
            CHUtilityFunctions().showAlert(message: "Selected Dish has Already Been Bought.", from: self)
        }
        else
        {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHPlaceOrderViewController") as? CHPlaceOrderViewController)!
            vc.hidesBottomBarWhenPushed = true
            vc.objDish = self.objDish
            vc.objCheif = self.objCheif
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }

    // Back button action
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // Submit rating action
    @IBAction func btnSubmitRating_Pressed(_ sender: Any) {
        if self.selectedRating != 0 {
            let myUserID = Auth.auth().currentUser?.uid
            let rating = self.selectedRating
            let dishId = self.objDish.id
            let dict = ["rating": rating, "userId": myUserID!, "dishId": dishId!] as [String: Any]
            ref.child("dishes").child((self.objDish.id)!).child("ratings").child(myUserID!).setValue(dict)
            self.viewRating.isHidden = true
            CHUtilityFunctions().removeBlurEffect(viewToRemoveBlur: self.viewBody)
            CHUtilityFunctions().removeBlurEffect(viewToRemoveBlur: self.viewHeader)
        } else {
            print("No Rating Selected")
        }
    }

    // Rate dish action
    @IBAction func btnRateDish_Pressed(_ sender: Any) {
        CHUtilityFunctions().blurEffect(viewToBlur: self.viewBody)
        CHUtilityFunctions().blurEffect(viewToBlur: self.viewHeader)
        self.viewRating.isHidden = false
    }

    // Show alert
    func showAlertView(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension CHDishDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objDish.selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishDetailViewControllerCollectionViewCell", for: indexPath) as! DishDetailViewControllerCollectionViewCell
        let objImage = self.objDish.selectedImages as! [CHDishImageModel]
        let temp = objImage[indexPath.item]
        cell.DishDetailControllerCellImage.sd_setImage(with: URL(string: temp.imageUrl ?? ""))
        cell.DishDetailControllerCellImage.layer.cornerRadius = 10
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameSize = collectionView.frame.size
        return CGSize(width: (frameSize.width / 1.8) - 5, height: frameSize.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
