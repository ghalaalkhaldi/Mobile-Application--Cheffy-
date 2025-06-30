
import Foundation

// Custom class representing dish image model
class CHDishBuyModel: NSObject {
    
    // Properties representing dish image data
    
    var dishId: String?
    var timestamp: Int?
    var dishImage:String?
    var dishPrice:String?
    var dishName:String?
    var dishCategory:String?
    var cheifName:String?
    var chefId:String?
    var userId:String?
    var chefCategory:String?
    var chefEmail:String?
    var chefPhoneNo:String?
    var chefImage:String?
    var status:String?
    
    
    // Method to save single image from dictionary
    func saveDishBuy(dict: NSDictionary?) -> NSMutableArray? {
        let arrImages: NSMutableArray = []
        let objImage = CHDishBuyModel(dict: dict!)
        arrImages.add(objImage!)
        return arrImages
    }
    
    // Method to save multiple images from response array
    func saveDishBuy(responseArray: NSArray?) -> NSMutableArray? {
        let arrImages: NSMutableArray = []
        for dict in responseArray! {
            let objImage = CHDishBuyModel(dict: dict as! NSDictionary)
            arrImages.add(objImage!)
        }
        return arrImages
    }
    
    // Method to get images from response array
    func getDishBuy(responseArray: NSMutableArray?) -> NSMutableArray? {
        let arr: NSMutableArray = []
        for dict in responseArray! {
            let objModel = CHDishBuyModel(dict: dict as! NSDictionary)
            arr.add(objModel!)
        }
        return arr
    }
    
    // Convenience initializer to initialize object from dictionary
    convenience init?(dict dictUsers: NSDictionary) 
    {
        self.init()
        self.dishId = dictUsers["dishId"] as? String
        self.timestamp = dictUsers["timestamp"] as? Int
        self.dishImage = dictUsers["dishImage"] as? String
        self.dishPrice = dictUsers["dishPrice"] as? String
        self.dishName = dictUsers["dishName"] as? String
        self.dishCategory = dictUsers["dishCategory"] as? String
        self.cheifName = dictUsers["cheffName"] as? String
        self.chefId = dictUsers["chefId"] as? String
        self.userId = dictUsers["userId"] as? String
        self.chefCategory = dictUsers["chefCategory"] as? String
        self.chefPhoneNo = dictUsers["chefPhoneNo"] as? String
        self.chefEmail = dictUsers["chefEmail"] as? String
        self.chefImage = dictUsers["chefImage"] as? String
        self.status = dictUsers["status"] as? String
    }
}
