
import UIKit
import Foundation //ios development
import UIKit //ios development
import SVProgressHUD //library for displaying loading indicators
import Firebase //Used for authentication and potentially database operations.
import SDWebImage //Simplifies image loading from URLs.
import ChatSDK // Libraries for real-time chat functionality.
import ChatSDKFirebase // Libraries for real-time chat functionality.

class CHChefProfileDetailViewController: UIViewController {

    //@IBOutlet connections: Link UI elements to code variables.
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnContactMe: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    
    var entityId = "" // The unique identifier of the chef whose profile is being displayed
    var objChef = CHUserModel() //An object to hold the chef's data custom model
    var isChatOpenAlready = false //Tracks whether a chat with this chef is already open.
    var objCurrentUser = CHUserModel() //Holds the data of the currently logged-in user.
    
    override func viewDidLoad() // the view controller is loaded
    {
        super.viewDidLoad()
        print(entityId)
        self.viewSetup()
        self.getCurrentUser()
    }
    
    override func viewDidLayoutSubviews() //after the view's layout is finalized
    {
        if self.entityId != ""
        {
            self.getCurrentUser()
            self.apiCall()
        }
    }
    
    @IBAction func btnBack_Pressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContactMe_Pressed(_ sender: Any) {
        // Set up users for chat
        let objOtherUser = self.objChef //Assign the 'objChef' (another user) to a local variable.
        let wrapper1: CCUserWrapper = CCUserWrapper.user(withEntityID: self.objCurrentUser.userId) //Create a wrapper for the current user's data.
        wrapper1.metaOn() //Enable metadata (additional information) for the wrapper.
        let user1 : PUser = wrapper1.model() //Get the user's data model (for a chat).
        user1.setName(self.objCurrentUser.firstName) //Set the user's name in the data model.
        wrapper1.push() //Update the user's data (in a database).
        let wrapper2:CCUserWrapper = CCUserWrapper.user(withEntityID: objOtherUser.userId) //Create a wrapper for the other user's data.
        wrapper2.metaOn() //Enable metadata for the other user's wrapper.
        let user2 : PUser = wrapper2.model() //Get the other user's data model.
        user2.setName(objOtherUser.firstName) //Set the other user's name in the data model.
        wrapper2.push() //Update the other user's data.
        let users : Array = [user1, user2] //Create an array containing both user data models.

        // Check if chat is already open
        let array = BChatSDK.core().threads(with: bThreadType1to1) //Fetch an array of existing threads of type "1to1" (one-to-one chats) from the chat SDK.
        let arrayThread = array as! [PThread] //Cast the retrieved array to an array of `PThread` objects (assuming `PThread` is your custom thread class).
        for i in arrayThread { //Iterate through each thread in the array.
            if i.otherUser().entityID() == objOtherUser.userId { //Check if the current thread is with the 'objOtherUser' (the user you're trying to chat with)
                self.isChatOpenAlready = true //Set a flag to indicate that a chat with this user is already open.
                i.otherUser().entityID() // Get the entity ID of the other user in the thread (this line seems redundant and might be removed).
                i.markRead() //Mark the thread as read.
                
                // --- Chat View Controller Initialization and Presentation ---
                let chatViewController = BChatSDK.ui().chatViewController(with:i) //Create a chat view controller using the BChatSDK UI for the current thread.
                let controller = BChatViewController.init(thread: i) //Create another chat view controller (likely a custom subclass) using the current thread.
                
                controller?.updateTitle() //Update the title of the custom chat view controller.
                controller?.doViewWillDisappear(true) //Call a custom method (likely for cleanup) when the view is about to disappear.
                i.markRead() //Mark the thread as read again (this might be redundant).
                
                chatViewController?.modalPresentationStyle = .formSheet //Set the presentation style of the BChatSDK chat view controller to "formSheet."
                self.navigationController?.navigationBar.isHidden = false //Ensure the navigation bar is visible.
                self.navigationController?.present(controller!, animated: true) //Present the custom chat view controller modally and animated.
            }
        }

        // If chat is not open, create new chat thread
        if isChatOpenAlready == false {
            BChatSDK.core().createThread(withUsers: users , threadCreated: {(error: Error?, thread:PThread?) in //Create a new thread with the specified users (the current user and the other user). The closure handles the result.
                if ((error) != nil) { //Check if an error occurred during thread creation.
                    print(error.debugDescription) //Print the error description for debugging if an error is found.
                } else { //If no error, the thread was created successfully.
                    let cvc = BChatSDK.ui().chatViewController(with: thread) //Create a chat view controller using the newly created thread.
                    self.navigationController?.navigationBar.isHidden = false //Ensure the navigation bar is visible.
                    self.navigationController?.modalPresentationStyle = .formSheet //Set the presentation style for the navigation controller (how the view will appear).
                    self.navigationController?.present(cvc!, animated: true) // Present the chat view controller modally (taking over the screen) with animation.
                }
            })
        }
    }
    
}

//MARK: View setup
extension CHChefProfileDetailViewController
{
    func viewSetup() //Configures the UI elements (labels, text fields, image view) with the chef's data.
    {
        self.txtName.isUserInteractionEnabled = false
        self.txtEmail.isUserInteractionEnabled = false
        self.txtCategory.isUserInteractionEnabled = false
        self.txtPhoneNumber.isUserInteractionEnabled = false
        self.txtViewDescription.isUserInteractionEnabled = false
        self.txtName.text = "\(objChef.firstName ?? "" ) \(objChef.lastName ?? "")"
        self.txtEmail.text = objChef.email
        self.txtCategory.text = objChef.category
        self.txtPhoneNumber.text = objChef.phoneNumber
        self.txtViewDescription.text = objChef.chefDescription
        
        let resturantImage = objChef.certificatesImages as! [CHDishImageModel] //Get an array of image models (certificates) associated with the "chef" object. We're assuming these are actually restaurant images based on context.

        if resturantImage.count > 0 { //Check if there are any restaurant images available.
            self.imgProfile.sd_setImage(with: URL(string: self.objChef.profilePic ?? ""), placeholderImage: UIImage(named: "person"))
            // If images exist, use the 'sd_setImage' method (likely from the SDWebImage library) to load the first image from the 'profilePic' URL.
            // Use a placeholder image ("person") while the image is loading or if the URL is invalid.
        }
        else
        {
            self.imgProfile.image = UIImage(named: "person") // If no images, set the profile image to the default "person" placeholder.
        }
        imgProfile.layer.cornerRadius = 50 //Round the corners of the profile image for visual styling.
        self.btnContactMe.layer.cornerRadius = 20 //Round the corners of the "Contact Me" button.
        if self.objChef.userType == "Resturant" //Check if the user type of the "chef" object is "Resturant."
        {
            self.lblDescription.isHidden =  true //If it's a restaurant, hide the description label.
            self.txtViewDescription.isHidden = true // Also, hide the description text view.
        }
        else
        {
            self.lblDescription.isHidden =  false //If it's not a restaurant, show the description label.
            self.txtViewDescription.isHidden = false //Show the description text view as well.
        }
    }
}


extension CHChefProfileDetailViewController
{
    func apiCall()
    {
        CHProfileAPIManager().getUserProfile(userId: entityId)
        { array, isSuccessfull in
            if isSuccessfull
            {
                self.objChef = array![0] as! CHUserModel
                self.viewSetup()
            }
            else
            {
              print("user not found")
            }
        }
    }
    func getCurrentUser()
    {
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid ?? "")
        { array, isSuccessfull in
            if isSuccessfull
            {
                self.objCurrentUser = array![0] as! CHUserModel
                //self.viewSetup()
            }
            else
            {
              print("user not found")
            }
        }
    }
}
