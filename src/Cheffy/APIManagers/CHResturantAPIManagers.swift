
import Foundation
import Firebase
class CHResturantAPIManager:NSObject
{
    var completionBlock: (( _ message: String?, _ isSuccessfull: Bool) -> Void)?
    var completionBlockArray: ((_ array: NSMutableArray?, _ isSuccessfull: Bool) -> Void)?
    var completionBlockWithArrays: ((_ array: NSMutableArray?, _ arraySecond: NSMutableArray?, _ isSuccessfull: Bool) -> Void)?
    var params : NSDictionary = [:]
    var ref : DatabaseReference!
    

    func createResturants(title : String?, selectedImages : [UIImage] ,email:String?,phoneNo:String,address:String,id:UUID,postedByName:String,completionBlock: @escaping (_ message: String?,  _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlock = completionBlock;
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
      //  let user = Auth.auth().currentUser
        let resturantId = ref.child("resturants").childByAutoId().key!
        self.ref.child("resturants/\(resturantId)/id").setValue(resturantId)
        self.ref.child("resturants/\(resturantId)/title").setValue(title)
        self.ref.child("resturants/\(resturantId)/email").setValue(email)
        self.ref.child("resturants/\(resturantId)/phoneNo").setValue(phoneNo)
        self.ref.child("resturants/\(resturantId)/address").setValue(address)
        self.ref.child("resturants/\(resturantId)/postedBy").setValue(userID)
        self.ref.child("resturants/\(resturantId)/timestamp").setValue(ServerValue.timestamp())
        self.ref.child("resturants/\(resturantId)/postedByName").setValue(postedByName)
        
        for i in 0..<selectedImages.count
        {
            let imageKey = randomString(length: 20)
            guard let data = selectedImages[i].jpegData(compressionQuality: 0.5) else { return }
            self.uploadImage(dataImage: data, imageKey: imageKey, completion: {(url,isSuccess) in
                if(isSuccess)
                {
                    let dict = ["id":imageKey,
                                "imageUrl":url]
                    as [String:Any]
                    self.ref.child("resturants").child("\(resturantId )").child("selectedImages").child(imageKey).setValue(dict)
                    completionBlock("success", true)
                }
            })
        }
        completionBlock(userID, true)
        
    }
    func uploadImage(dataImage : Data,imageKey: String,completion: @escaping ( _ url: String, _ success: Bool) -> Void)
    {
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageName = "products-image" + imageKey
        let storageRef = Storage.storage().reference().child("productsImages/").child(imageName)
        storageRef.putData(dataImage, metadata: metaData, completion: { (metadata, error)in
            if error != nil {
                print("error uploading image \(error!.localizedDescription)")
                
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    
                    completion("",false)
                    return
                }
                completion(downloadURL.absoluteString,true)
            }
        })
    }
    func randomString(length: Int) -> String
    {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    func getAllResturants(completionBlockArray: @escaping (  _ array: NSMutableArray?,   _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlockArray = completionBlockArray
        ref = Database.database().reference()
        var arrayPosts : NSMutableArray = []
        ref.child("resturants").queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value, with: {(snapshot) in
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
                arrayPosts = CHResturantModel().getResturant(responseArray: arrayPosts)!
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
