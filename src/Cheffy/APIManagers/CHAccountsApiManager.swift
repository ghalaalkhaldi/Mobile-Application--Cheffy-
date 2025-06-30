

import Foundation
import UIKit
import Firebase

class CHAccountsAPIManager: NSObject {
    
    var completionBlock: ((_ message: String?,  _ isSuccessfull: Bool) -> Void)?
    var completionBlockArray: (( _ array: NSMutableArray?,  _ isSuccessfull: Bool) -> Void)?
    var params : NSDictionary = [:]
    var ref : DatabaseReference!
    
    
    func createChef(firstName : String?, lastName : String?, email: String?, password: String?, userType : String?,phoneNumber:String,address:String,chefDescription:String,selectedImages : [UIImage],category:String,completionBlock: @escaping (_ message: String?,  _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlock = completionBlock;
        ref = Database.database().reference()
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
            if error == nil
            {
                let userID = Auth.auth().currentUser?.uid
                let user = Auth.auth().currentUser
                var emailAddress : String?
                emailAddress = email
                self.ref.child("users/\(user!.uid)/firstName").setValue(firstName)
                self.ref.child("users/\(user!.uid)/lastName").setValue(lastName)
                self.ref.child("users/\(user!.uid)/email").setValue(emailAddress)
                self.ref.child("users/\(user!.uid)/userId").setValue(userID)
                self.ref.child("users/\(user!.uid)/userType").setValue(userType)
                self.ref.child("users/\(user!.uid)/phoneNumber").setValue(phoneNumber)
                self.ref.child("users/\(user!.uid)/address").setValue(address)
                self.ref.child("users/\(user!.uid)/chefDescription").setValue(chefDescription)
                self.ref.child("users/\(user!.uid)/category").setValue(category)
                
                for i in 0..<selectedImages.count
                {
                    let imageKey = self.randomString(length: 20)
                    guard let data = selectedImages[i].jpegData(compressionQuality: 0.5) else { return }
                    self.uploadImageChef(dataImage: data, imageKey: imageKey, completion: {(url,isSuccess) in
                        if(isSuccess)
                        {
                            let dict = ["id":imageKey,
                                        "imageUrl":url]
                            as [String:Any]
                            self.ref.child("users").child("\(user!.uid )").child("certificatesImages").child(imageKey).setValue(dict)
                            completionBlock("success", true)
                        }
                    })
                }
                completionBlock(userID, true)
            }
            else{
                completionBlock(error?.localizedDescription, false)
            }
        }
    }
    
    func createResturant(resturantName : String?, email: String?, password: String?, userType : String?,phoneNumber:String,address:String,selectedImages : [UIImage],category:String,completionBlock: @escaping (_ message: String?,  _ isSuccessfull: Bool) -> Void)
    {
        self.completionBlock = completionBlock;
        ref = Database.database().reference()
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
            if error == nil
            {
                let userID = Auth.auth().currentUser?.uid
                let user = Auth.auth().currentUser
                var emailAddress : String?
                emailAddress = email
                self.ref.child("users/\(user!.uid)/firstName").setValue(resturantName)
                self.ref.child("users/\(user!.uid)/email").setValue(emailAddress)
                self.ref.child("users/\(user!.uid)/userId").setValue(userID)
                self.ref.child("users/\(user!.uid)/userType").setValue(userType)
                self.ref.child("users/\(user!.uid)/phoneNumber").setValue(phoneNumber)
                self.ref.child("users/\(user!.uid)/address").setValue(address)
                self.ref.child("users/\(user!.uid)/category").setValue(category)
                
                for i in 0..<selectedImages.count
                {
                    let imageKey = self.randomString(length: 20)
                    guard let data = selectedImages[i].jpegData(compressionQuality: 0.5) else { return }
                    self.uploadImageResturant(dataImage: data, imageKey: imageKey, completion: {(url,isSuccess) in
                        if(isSuccess)
                        {
                            let dict = ["id":imageKey,
                                        "imageUrl":url]
                            as [String:Any]
                            self.ref.child("users").child("\(user!.uid )").child("certificatesImages").child(imageKey).setValue(dict)
                            completionBlock("success", true)
                        }
                    })
                }
                completionBlock(userID, true)
            }
            else
            {
                completionBlock(error?.localizedDescription, false)
            }
        }
    }
    
    func uploadImageChef(dataImage : Data,imageKey: String,completion: @escaping ( _ url: String, _ success: Bool) -> Void)
    {
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageName = "Certificates-image" + imageKey
        let storageRef = Storage.storage().reference().child("certificatesImages/").child(imageName)
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
    func uploadImageResturant(dataImage : Data,imageKey: String,completion: @escaping ( _ url: String, _ success: Bool) -> Void)
    {
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageName = "Resturant-image" + imageKey
        let storageRef = Storage.storage().reference().child("resturantImages/").child(imageName)
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
    
    
 
    
    func loginViaEmail(withEmail : String?, password : String?, completionBlock: @escaping (_ message: String?,  _ isSuccessfull: Bool) -> Void)
    {
        ref = Database.database().reference()
        Auth.auth().signIn(withEmail: withEmail!, password: password!) { authResult, error in
            if error == nil{
                let userID = authResult!.user.uid
                print(userID)
                CHUtilityFunctions().setLoggedInUserID(userID)
                completionBlock(userID, true)
            }
            else{
                print(error?.localizedDescription as Any)
                completionBlock(error?.localizedDescription, false)
            }
        }
    }
    
    func forgotPassword(withEmail: String?, completionBlock: @escaping (_ message: String?,  _ isSuccessfull: Bool) -> Void)
    {
        Auth.auth().sendPasswordReset(withEmail: withEmail!, completion: { (error) in
            if let error = error as NSError?
            {
                completionBlock(error.localizedDescription,false)
            }
            else
            {
                completionBlock("Success",true)
            }
        })
    }  
    
   
}
