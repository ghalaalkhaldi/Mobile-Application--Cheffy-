

import Foundation

class CHUserModel: NSObject {
    
    // Properties representing user data
    var address: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var userType: String?
    var userId: String?
    var profilePic: String?
    var category:String?
    var chefDescription:String?
    var certificatesImages: NSMutableArray = []
    var arrDishBuy: NSMutableArray = []
    
    
    // Method to save user data from dictionary
    func saveUser(dict: NSDictionary?) -> NSMutableArray? {
        let arrUser: NSMutableArray = []
        let objProfile = CHUserModel(dict: dict!)
        arrUser.add(objProfile!)
        return arrUser
    }
    
    // Method to get all users from response array
    func getAllUsers(responseArray: NSMutableArray?) -> NSMutableArray? {
        let arr: NSMutableArray = []
        for dict in responseArray! {
            let objModel = CHUserModel(dict: dict as! NSDictionary)
            if objModel?.firstName != "" {
                arr.add(objModel!)
            }
        }
        return arr
    }
    
    // Convenience initializer to initialize object from dictionary
    convenience init?(dict dictUsers: NSDictionary) {
        self.init()
        self.userId = dictUsers["userId"] as? String
        self.firstName = dictUsers["firstName"] as? String
        self.lastName = dictUsers["lastName"] as? String
        self.email = dictUsers["email"] as? String
        self.phoneNumber = dictUsers["phoneNumber"] as? String
        self.userType = dictUsers["userType"] as? String
        self.address = dictUsers["address"] as? String
        self.profilePic = dictUsers["profilePic"] as? String
        self.category = dictUsers["category"] as? String
        self.chefDescription = dictUsers["chefDescription"] as? String
        if let dict = dictUsers["certificatesImages"] as? [String: AnyObject] {
            for (_, value) in dict {
                let arrList = CHDishImageModel().saveImage(dict: value as? NSDictionary)!
                self.certificatesImages.add(arrList[0])
            }
        }
        if let dict = dictUsers["dishBuy"] as? [String: AnyObject] {
            for (_, value) in dict {
                let arrList = CHDishBuyModel().saveDishBuy(dict: value as? NSDictionary)!
                self.arrDishBuy.add(arrList[0])
            }
        }
    }
    
    // Convenience initializer to initialize object with specified properties
    convenience init(userId: String, firstName: String, lastName: String, email: String, phoneNumber: String, userType: String, address: String, profilePic: String,category:String,chefDescription:String,certificatesImages:NSMutableArray) {
        self.init()
        self.userId = userId
        self.chefDescription = chefDescription
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.userType = userType
        self.address = address
        self.profilePic = profilePic
        self.category = category
        self.certificatesImages = certificatesImages
    }
}

    

