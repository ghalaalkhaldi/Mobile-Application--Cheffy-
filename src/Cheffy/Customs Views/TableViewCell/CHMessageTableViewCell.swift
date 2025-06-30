
import UIKit
import ChatSDK
import Firebase

// Custom UITableViewCell subclass for displaying chat messages
class CHMessageTableViewCell: UITableViewCell {

    // Outlets for UI elements in the cell
    @IBOutlet weak var lblTime: UILabel! // Label for displaying message timestamp
    @IBOutlet weak var lblMessage: UILabel! // Label for displaying message text
    @IBOutlet weak var lblMessageSender: UILabel! // Label for displaying message sender
    @IBOutlet weak var imgProfile: UIImageView! // Image view for displaying profile image
    @IBOutlet weak var viewMain: UIView! // Main view containing all UI elements
    
    // Called after the view controller has loaded its view hierarchy into memory
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgProfile.isUserInteractionEnabled = true
        // Additional customization code can go here
    }

    // Called when the cell is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Set selection style to none
        super.selectionStyle = .none
        // Additional customization code for selected state can go here
    }
    
    // Function to populate cell with data
    func populateCell(objThread: PThread) {
        // Set message sender name
        self.lblMessageSender.text = objThread.displayName()
        
        // Check if message sender name is empty
        if self.lblMessageSender.text == "" {
            self.lblMessageSender.text = ""
        }
        
        // Get newest message in thread
        if let msg: PMessage = objThread.newestMessage() {
            self.lblMessage.text = msg.text() // Set message text
        }
        
        // Get creation date of thread
        let date = objThread.creationDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        self.lblTime.text = dateFormatter.string(from: date!) // Set message timestamp
        
        // Get profile image for message sender
        getProfileImage(objThread: objThread)
    }
    
    // Function to get profile image for message sender
    func getProfileImage(objThread: PThread) {
        let userId = Auth.auth().currentUser?.uid // Get current user's ID
        
        // Check if thread creator exists
        guard let creator = objThread.creator() else {
            self.imgProfile.image = UIImage(named: "imgOnlyForMe") // Set default image
            return
        }
        
        // Get creator's ID
        if let creatorId = creator.entityID() {
            // Check if current user is the creator
            if userId == creatorId {
                let nonCreatorImage = objThread.otherUser().image() // Get profile image of other user
                if nonCreatorImage == nil {
                    self.imgProfile.image = UIImage(named: "imgOnlyForMe") // Set default image
                } else {
                    let image = UIImage(data: nonCreatorImage!)
                    self.imgProfile.image = image // Set profile image
                }
            } else {
                let creatorImage = creator.image() // Get creator's profile image
                if creatorImage == nil {
                    self.imgProfile.image = UIImage(named: "imgOnlyForMe") // Set default image
                } else {
                    let image = UIImage(data: creatorImage!)
                    self.imgProfile.image = image // Set profile image
                }
            }
        }
    }
}
