
import Foundation

// Custom class representing dish image model
class CHDishImageModel: NSObject {
    
    // Properties representing dish image data
    var id: String?
    var imageUrl: String?
    
    // Method to save single image from dictionary
    func saveImage(dict: NSDictionary?) -> NSMutableArray? {
        let arrImages: NSMutableArray = []
        let objImage = CHDishImageModel(dict: dict!)
        arrImages.add(objImage!)
        return arrImages
    }
    
    // Method to save multiple images from response array
    func saveImages(responseArray: NSArray?) -> NSMutableArray? {
        let arrImages: NSMutableArray = []
        for dict in responseArray! {
            let objImage = CHDishImageModel(dict: dict as! NSDictionary)
            arrImages.add(objImage!)
        }
        return arrImages
    }
    
    // Method to get images from response array
    func getImages(responseArray: NSMutableArray?) -> NSMutableArray? {
        let arr: NSMutableArray = []
        for dict in responseArray! {
            let objModel = CHDishImageModel(dict: dict as! NSDictionary)
            arr.add(objModel!)
        }
        return arr
    }
    
    // Convenience initializer to initialize object from dictionary
    convenience init?(dict dictUsers: NSDictionary) {
        self.init()
        self.id = dictUsers["id"] as? String
        self.imageUrl = dictUsers["imageUrl"] as? String
    }
}
