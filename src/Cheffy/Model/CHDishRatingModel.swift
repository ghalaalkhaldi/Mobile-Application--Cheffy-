
import Foundation
class CHDishRatingModel: NSObject {

    var rating:Int?
    var userId:String?
    var videoId:String?
    
    
    func saveRating(dict: NSDictionary?) -> NSMutableArray? {
        
        let arrRating: NSMutableArray = []
        
        let objRating = CHDishRatingModel.init(dict: dict!)
        arrRating.add(objRating!)
        return arrRating
    }
    
    func saveRating(responseArray: NSArray?) -> NSMutableArray? {
        
        let arrRating: NSMutableArray = []
        
        for dict in responseArray!
        {
            let objRating = CHDishRatingModel.init(dict: dict as! NSDictionary)
            print(objRating!)
            arrRating.add(objRating!)
        }
        return arrRating
    }
    
    func getRating(responseArray: NSMutableArray?) -> NSMutableArray?
    {
        let arr: NSMutableArray = []
        for dict in responseArray!
        {
            let objModel = CHDishRatingModel.init(dict: dict as! NSDictionary)
            print(objModel!)
            arr.add(objModel!)
        }
        return arr
    }
    convenience init?(dict dictUsers: NSDictionary)
    {
        self.init()
        self.rating = dictUsers["rating"] as? Int
        self.userId = dictUsers["userId"] as? String
        self.videoId = dictUsers["videoId"] as? String
    }
}
