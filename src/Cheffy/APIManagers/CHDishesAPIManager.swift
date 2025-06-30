

import Foundation
import Firebase

class CHDishesAPIManager:NSObject
{
    var completionBlock: (( _ message: String?, _ isSuccessfull: Bool) -> Void)?
    var completionBlockArray: ((_ array: NSMutableArray?, _ isSuccessfull: Bool) -> Void)?
    var completionBlockWithArrays: ((_ array: NSMutableArray?, _ arraySecond: NSMutableArray?, _ isSuccessfull: Bool) -> Void)?
    var params : NSDictionary = [:]
    var ref : DatabaseReference!
    

    func createDishes(title : String?, selectedImages : [UIImage] ,description: String?, category: String?, price : String?,email:String?,phoneNo:String,address:String,id:UUID,postedByName:String,completionBlock: @escaping (_ message: String?,  _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlock = completionBlock;
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        //let user = Auth.auth().currentUser
        let disehesId = ref.child("dishes").childByAutoId().key!
        self.ref.child("dishes/\(disehesId)/id").setValue(disehesId)
        self.ref.child("dishes/\(disehesId)/title").setValue(title)
        self.ref.child("dishes/\(disehesId)/description").setValue(description)
        self.ref.child("dishes/\(disehesId)/category").setValue(category)
        self.ref.child("dishes/\(disehesId)/price").setValue(price)
        self.ref.child("dishes/\(disehesId)/email").setValue(email)
        self.ref.child("dishes/\(disehesId)/phoneNo").setValue(phoneNo)
        self.ref.child("dishes/\(disehesId)/address").setValue(address)
        self.ref.child("dishes/\(disehesId)/postedBy").setValue(userID)
        self.ref.child("dishes/\(disehesId)/timestamp").setValue(ServerValue.timestamp())
        self.ref.child("dishes/\(disehesId)/postedByName").setValue(postedByName)
        
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
                    self.ref.child("dishes").child("\(disehesId )").child("selectedImages").child(imageKey).setValue(dict)
                  //  completionBlock("success", true)
                }
            })
        }
        completionBlock(userID, true)
        
    }
    func buyDish(userId:String,dishName : String, dishId : String ,dishCategory: String, dishPrice: String, dishImage : String,cheffName:String,chefId:String,chefCategory:String,chefPhoneNo:String,chefEmail:String,chefImage:String,completionBlock: @escaping (_ message: String?,  _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlock = completionBlock;
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        //let user = Auth.auth().currentUser
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("dishId").setValue(dishId)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("dishName").setValue(dishName)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("userId").setValue(userId)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("dishCategory").setValue(dishCategory)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("dishPrice").setValue(dishPrice)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("dishImage").setValue(dishImage)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("cheffName").setValue(cheffName)
        
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("chefId").setValue(chefId)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("chefEmail").setValue(chefEmail)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("chefCategory").setValue(chefCategory)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("chefPhoneNo").setValue(chefPhoneNo)
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("timestamp").setValue(ServerValue.timestamp())
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("status").setValue("open")
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("dishId").setValue(dishId)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("dishName").setValue(dishName)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("userId").setValue(userId)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("dishCategory").setValue(dishCategory)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("dishPrice").setValue(dishPrice)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("dishImage").setValue(dishImage)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("cheffName").setValue(cheffName)
        
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("chefId").setValue(chefId)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("chefEmail").setValue(chefEmail)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("chefCategory").setValue(chefCategory)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("chefPhoneNo").setValue(chefPhoneNo)
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("timestamp").setValue(ServerValue.timestamp())
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("status").setValue("open")
        
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
    
    
    func markAsClosed(dishId:String,chefId:String)
    {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("status").setValue("closed")
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("status").setValue("closed")
    }
    func markAsCancel(dishId:String,chefId:String)
    {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("status").setValue("cancel")
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("status").setValue("cancel")
    }
    func markAsPreparing(dishId:String,chefId:String)
    {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("status").setValue("preparing")
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("status").setValue("preparing")
    }
    func markAsReady(dishId:String,chefId:String)
    {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("users").child(userID ?? "").child("dishBuy").child(dishId).child("status").setValue("ready")
        
        self.ref.child("users").child(chefId).child("dishBuy").child(dishId).child("status").setValue("ready")
    }
    func randomString(length: Int) -> String
    {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    
    func getCategoryPosts(category:String,completionBlockArray: @escaping (  _ array: NSMutableArray?,   _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlockArray = completionBlockArray
        ref = Database.database().reference()
        var arrayPosts : NSMutableArray = []
        ref.child("dishes").observeSingleEvent(of: .value, with: {(snapshot) in
            if(snapshot.hasChildren() == true)
            {
                arrayPosts = []
                for childSnap in snapshot.children
                {
                    let userSnap = childSnap as! DataSnapshot
                    let dict = userSnap.value as! NSDictionary
                    let postCategory = dict["category"] as? String ?? ""
                    
                    if postCategory == category
                    {
                        arrayPosts.add(dict as NSDictionary)
                    }
                }
                //                var reversedArray = NSArray()
                //                reversedArray =  NSMutableArray(array:arrayPosts.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
                //                arrayPosts = reversedArray as! NSMutableArray
                arrayPosts = CHDishesModel().getAllDishes(responseArray: arrayPosts)!
                completionBlockArray(arrayPosts,true)
            }
            else
            {
                arrayPosts = []
                completionBlockArray( arrayPosts,false)
            }
        })
    }
    func getAllPosts(completionBlockArray: @escaping (  _ array: NSMutableArray?,   _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlockArray = completionBlockArray
        ref = Database.database().reference()
        var arrayPosts : NSMutableArray = []
        ref.child("dishes").queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value, with: {(snapshot) in
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
                arrayPosts = CHDishesModel().getDish(responseArray: arrayPosts)!
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

