
import Foundation

// Custom class representing dishes model
class CHDishesModel: NSObject {
    
    // Properties representing dish data
    var address: String?
    var category: String?
    var dishDescription: String?
    var email: String?
    var phoneNo: String?
    var id: String?
    var postedBy: String?
    var price: String?
    var selectedImages: NSMutableArray = []
    var title: String?
    var timeStamp: Int?
    var postedByName: String?
    var arrRatings : NSMutableArray? = []
    
    // Method to save dish from dictionary
    func saveDish(dict: NSDictionary?) -> NSMutableArray? {
        let arrUser: NSMutableArray = []
        let objProfile = CHDishesModel(dict: dict!)
        arrUser.add(objProfile!)
        return arrUser
    }
    
    // Method to get a dish from response array
    func getDish(responseArray: NSMutableArray?) -> NSMutableArray? {
        let arr: NSMutableArray = []
        for dict in responseArray! {
            if dict is NSDictionary {
                let objModel = CHDishesModel(dict: dict as! NSDictionary)
                arr.add(objModel!)
            }
        }
        return arr
    }
    
    // Method to get all dishes from response array
    func getAllDishes(responseArray: NSMutableArray?) -> NSMutableArray? {
        let arr: NSMutableArray = []
        for dict in responseArray! {
            let objModel = CHDishesModel(dict: dict as! NSDictionary)
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
        self.category = dictUsers["category"] as? String
        self.dishDescription = dictUsers["description"] as? String
        self.email = dictUsers["email"] as? String
        self.id = dictUsers["id"] as? String
        self.phoneNo = dictUsers["phoneNo"] as? String
        self.postedBy = dictUsers["postedBy"] as? String
        self.price = dictUsers["price"] as? String
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
        if let dict = dictUsers["ratings"] as? [String : AnyObject]
        {
            for (_,value) in dict
            {
                let arrList = CHDishRatingModel().saveRating(dict: value as? NSDictionary)!
                self.arrRatings?.add(arrList[0])
            }
        }
        
    }
    
    // Convenience initializer to initialize object with specified properties
    convenience init(id: String, phoneNo: String, dishDescription: String, email: String, address: String, title: String, selectedImages: NSMutableArray, postedBy: String, price: String, category: String, timeStamp: Int, postedByName: String) {
        self.init()
        self.id = id
        self.phoneNo = phoneNo
        self.dishDescription = dishDescription
        self.email = email
        self.address = address
        self.title = title
        self.selectedImages = selectedImages
        self.postedBy = postedBy
        self.price = price
        self.category = category
        self.timeStamp = timeStamp
        self.postedByName = postedByName
    }
}
