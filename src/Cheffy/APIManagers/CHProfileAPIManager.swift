
import Foundation
import Firebase

class CHProfileAPIManager:NSObject
{
    var completionBlock: (( _ message: String?, _ isSuccessfull: Bool) -> Void)?
    var completionBlockArray: ((_ array: NSMutableArray?, _ isSuccessfull: Bool) -> Void)?
    var completionBlockWithArrays: ((_ array: NSMutableArray?, _ arraySecond: NSMutableArray?, _ isSuccessfull: Bool) -> Void)?
    var params : NSDictionary = [:]
    var ref : DatabaseReference!
    
    
    func getUserProfile(userId : String?, completionBlockArray: @escaping (_ array: NSMutableArray?, _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlockArray = completionBlockArray
        ref = Database.database().reference()
        ref.keepSynced(true)
        var arrayProfile : NSMutableArray = []
        ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() == true
            {
                let dict = snapshot.value as! NSDictionary
                arrayProfile = CHUserModel().saveUser(dict: dict)!
                self.completionBlockArray!(arrayProfile,true)
            }
            else
            {
                self.completionBlockArray!([],false)
            }
        }, withCancel: { error in
            print("\(error.localizedDescription)")
        })
    }
    
    func getUserProfileObserver(userId: String?, completionBlockArray: @escaping (_ array: NSMutableArray?, _ isSuccessfull: Bool) -> Void) {
        guard let userId = userId else {
            completionBlockArray([], false)
            return
        }

        self.completionBlockArray = completionBlockArray
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        var arrayProfile: NSMutableArray = []

        ref.child("users").child(userId).observe(.value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            
            if snapshot.hasChildren() {
                if let dict = snapshot.value as? NSDictionary {
                    if let profileArray = CHUserModel().saveUser(dict: dict) {
                        arrayProfile = profileArray
                        self.completionBlockArray?(arrayProfile, true)
                    } else {
                        self.completionBlockArray?([], false)
                    }
                } else {
                    self.completionBlockArray?([], false)
                }
            } else {
                self.completionBlockArray?([], false)
            }
        }, withCancel: { error in
            print("\(error.localizedDescription)")
            self.completionBlockArray?([], false)
        })
    }

    
    
    func updateUserProfilePicture(userId: String?,imgData: Data?, completionBlock: @escaping ( _ message: String?, _ isSuccessfull: Bool?) -> Void)
    {
        self.completionBlock = completionBlock
        ref = Database.database().reference()
        ref.keepSynced(true)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageName = "profile_" + userId!
        let storageRef = Storage.storage().reference().child("images/").child(imageName)
        
        storageRef.putData(imgData!, metadata: metaData, completion: { (metadata, error)in
            if error != nil {
                print("error uploading image \(error!.localizedDescription)")
                
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionBlock("Error",false)
                    return
                }
                print("URL IS: \(downloadURL.absoluteString)")
                self.ref.child("users").child(userId!).child("profilePic").setValue(downloadURL.absoluteString)
                completionBlock("Succesfull",true)
            }
        })
    }
    func editUser(firstName : String?, lastName : String?,phoneNumber:String,address:String,completionBlock: @escaping (_ message: String?,  _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlock = completionBlock;
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid ?? ""
        self.ref.child("users/\(userID)/firstName").setValue(firstName)
        self.ref.child("users/\(userID)/lastName").setValue(lastName)
        self.ref.child("users/\(userID)/phoneNumber").setValue(phoneNumber)
        self.ref.child("users/\(userID)/address").setValue(address)
        completionBlock("SuccessFull",true)
    }
    func getAllUsers(completionBlockArray: @escaping (  _ array: NSMutableArray?,   _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlockArray = completionBlockArray
        ref = Database.database().reference()
        var arrayPosts : NSMutableArray = []
        ref.child("users").queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value, with: {(snapshot) in
            if(snapshot.hasChildren() == true)
            {
                arrayPosts = []
                for childSnap in snapshot.children
                {
                    let userSnap = childSnap as! DataSnapshot
                    let dict = userSnap.value as! NSDictionary
                    arrayPosts.add(dict as NSDictionary)
                }
                var reversedArray = NSArray()
                reversedArray =  NSMutableArray(array:arrayPosts.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
                arrayPosts = reversedArray as! NSMutableArray
                arrayPosts = CHUserModel().getAllUsers(responseArray: arrayPosts)!
                completionBlockArray(arrayPosts,true)
            }
            else
            {
                arrayPosts = []
                completionBlockArray( arrayPosts,false)
            }
        })
    }
}
