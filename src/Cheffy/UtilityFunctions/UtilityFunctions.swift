


import Foundation
import UIKit
class CHUtilityFunctions : NSObject
{
    
    func convertDateFormater( mydate : Date, format : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let dateString = dateFormatter.string(from: mydate)
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = format
        return  dateFormatter.string(from: date!)
        
    }
    func convertDateToReadableFormat( mydate : Date, format : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM 'at' hh:mm a"
        let dateString = dateFormatter.string(from: mydate)
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = format
        return  dateFormatter.string(from: date!)
        
    }
    
    func convertStringToDate(date1:String, format : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from:date1)
        return date!
        
        
    }
    
    func addShadowToButton (button : UIButton)
    {
        button.layer.shadowColor = UIColor.init(red: 221.0/255.0, green: 73.0/255.0, blue: 7.0/255.0, alpha: 0.91).cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.7
    }
    
    func addWhiteCircleToImage (image : UIImageView)
    {
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.bounds.width / 2
    }
    
    func showAlert(message: String, from controller: UIViewController)
    {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        controller.present(alert, animated: true)
    }
    
    func convert12hoursto24hours(time:String) -> String
    {
        let dateAsString = time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: dateAsString)
        
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from:date!)
        return date24
    }
    
    func convert12hoursto24hoursWithSeconds(time:String) -> String
    {
        let dateAsString = time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: dateAsString)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let date24 = dateFormatter.string(from:date!)
        return date24
    }
    
    func convert24hoursto12hours(time:String) -> String
    {
        let dateAsString = time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        
        dateFormatter.dateFormat = "hh:mm a"
        let date24 = dateFormatter.string(from:date!)
        return date24
    }
    
    func isValidEmailAddress(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func setLoggedInUserID(_ userID: String?)
    {
        UserDefaults.standard.setValue(userID, forKey: "UserID")
        UserDefaults.standard.synchronize()
    }
    
    func setIsDoctor()
    {
        UserDefaults.standard.set(true, forKey: "isDoctor")
        UserDefaults.standard.synchronize()
    }
    
    func getIsDoctor() -> Bool?
    {
        let isDoctor = UserDefaults.standard.bool(forKey: "isDoctor")
        return isDoctor
    }
    
    //MARK:- User Logged In
    
    func getLoggedInUserID() -> String? {
        let userID = UserDefaults.standard.value(forKey: "UserID") as? String
        return userID
    }
    
    func deleteLoggedInUser()
    {
        UserDefaults.standard.removeObject(forKey: "UserID")
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- Fonts Size and names
    
    func regularTextSize(_ theFontSize: CGFloat) -> UIFont? {
        return UIFont(name: CHStringConstants.Font.regularFont, size: theFontSize)
    }
    
    func regularBookTextSize(_ theFontSize: CGFloat) -> UIFont? {
        return UIFont(name: CHStringConstants.Font.regularBookFont, size: theFontSize)
    }
    
    func mediumTextSize(_ theFontSize: CGFloat) -> UIFont? {
        return UIFont(name: CHStringConstants.Font.mediumFont, size: theFontSize)
    }
    
    func boldTextSize(_ theFontSize: CGFloat) -> UIFont? {
        return UIFont(name: CHStringConstants.Font.boldFont, size: theFontSize)
    }
    
    func lightTextSize(_ theFontSize: CGFloat) -> UIFont? {
        return UIFont(name: CHStringConstants.Font.lightFont, size: theFontSize)
    }
    func blackTextSize(_ theFontSize: CGFloat) -> UIFont? {
        return UIFont(name: CHStringConstants.Font.blackFont, size: theFontSize)
    }
    func bodyTextSize(_ theFontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-LT-Std", size: 13.0)
    }
    
    //MARK:- Resize Image
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //MARK:- Svvae Profile Object
    
    //    func saveProfileObject(array : NSMutableArray)
    //    {
    //        let objProfile = array.firstObject as! CLProfileModel
    //        let userDefaults = UserDefaults.standard
    //        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: objProfile)
    //        userDefaults.set(encodedData, forKey: "profileObject")
    //        userDefaults.synchronize()
    //    }
    //
    //    func getProfileObject() -> CLProfileModel
    //    {
    //        let userDefaults = UserDefaults.standard
    //        let decoded  = userDefaults.data(forKey: "profileObject")
    //        let objProfileDecoded : CLProfileModel = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! CLProfileModel
    //        return objProfileDecoded
    //    }
    
    func deleteProfileObject()
    {
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "profileObject")
        userDefaults.set(nil, forKey: "profileObject")
        userDefaults.synchronize()
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    func setTabrBarImages(tabBarController : UITabBarController)
    {
        let leftTab = (tabBarController.tabBar.items?[0])! as UITabBarItem
        let rightTab = (tabBarController.tabBar.items?[4])! as UITabBarItem
        leftTab.image = UIImage(named: "leftSwipe")
        rightTab.image = UIImage(named: "rigghtSwipe")
    }
    
    func removeTabBarImages(tabBarController : UITabBarController)
    {
        let leftTab = (tabBarController.tabBar.items?[0])! as UITabBarItem
        let rightTab = (tabBarController.tabBar.items?[4])! as UITabBarItem
        leftTab.image = UIImage(named: "")
        rightTab.image = UIImage(named: "")
    }
    
    func setupNavBar(navController : UINavigationController , title : String , viewController : UIViewController)
    {
        
        navController.navigationBar.isTranslucent = true
        
        viewController.navigationItem.title = title
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupNavBarAppearence()
    {
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.clear
        UINavigationBar.appearance().layer.borderWidth = 0.0
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 20)!,NSAttributedString.Key.foregroundColor:UIColor.black]
        UINavigationBar.appearance().clipsToBounds = true
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func blurEffect(viewToBlur: UIView)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = viewToBlur.bounds
        blurEffectView.alpha = 0.5
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewToBlur.addSubview(blurEffectView)
    }
    
    func removeBlurEffect(viewToRemoveBlur: UIView)
    {
        for subview in viewToRemoveBlur.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func getReadableDate(timeStamp: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }

    func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
}
