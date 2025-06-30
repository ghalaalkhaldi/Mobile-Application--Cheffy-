

import Foundation

// Custom class representing restaurant model
class CHResturantModel: NSObject {
    
    // Properties representing restaurant data
    var address: String?
    var email: String?
    var phoneNo: String?
    var id: String?
    var postedBy: String?
    var selectedImages: NSMutableArray = []
    var title: String?
    var timeStamp: Int?
    var postedByName: String?
    
    // Method to save restaurant from dictionary
    func saveResturant(dict: NSDictionary?) -> NSMutableArray? {
        let arrUser: NSMutableArray = []
        let objProfile = CHResturantModel(dict: dict!)
        arrUser.add(objProfile!)
        return arrUser
    }
    
    // Method to get restaurant from response array
    func getResturant(responseArray: NSMutableArray?) -> NSMutableArray? {
        let arr: NSMutableArray = []
        for dict in responseArray! {
            if dict is NSDictionary {
                let objModel = CHResturantModel(dict: dict as! NSDictionary)
                arr.add(objModel!)
            }
        }
        return arr
    }
    
    // Method to get all dishes from response array
    func getAllDishes(responseArray: NSMutableArray?) -> NSMutableArray? {
        let arr: NSMutableArray = []
        for dict in responseArray! {
            let objModel = CHResturantModel(dict: dict as! NSDictionary)
            if objModel?.title != "" {
                arr.add(objModel!)
            }
        }
        return arr
    }
    
    // Convenience initializer to initialize object from dictionary
    convenience init?(dict dictUsers: NSDictionary) {
        self.init()
        self.address = dictUsers["address"] as? String
        self.email = dictUsers["email"] as? String
        self.id = dictUsers["id"] as? String
        self.phoneNo = dictUsers["phoneNo"] as? String
        self.postedBy = dictUsers["postedBy"] as? String
        self.title = dictUsers["title"] as? String
        self.postedByName = dictUsers["postedByName"] as? String
        self.timeStamp = dictUsers["timestamp"] as? Int
        
        // Extract selected images from dictionary and add to selectedImages array
        if let dict = dictUsers["selectedImages"] as? [String: AnyObject] {
            for (_, value) in dict {
                let arrList = CHDishImageModel().saveImage(dict: value as? NSDictionary)!
                self.selectedImages.add(arrList[0])
            }
        }
    }
    
    // Convenience initializer to initialize object with specified properties
    convenience init(id: String, phoneNo: String, email: String, address: String, title: String, selectedImages: NSMutableArray, postedBy: String, timeStamp: Int, postedByName: String) {
        self.init()
        self.id = id
        self.phoneNo = phoneNo
        self.email = email
        self.address = address
        self.title = title
        self.postedByName = postedByName
        self.selectedImages = selectedImages
        self.postedBy = postedBy
        self.timeStamp = timeStamp
    }
}

