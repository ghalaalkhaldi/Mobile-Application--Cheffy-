

import Foundation
import UIKit
extension UIFont {
    func setFontName(name : String, size : CGFloat) -> UIFont
    {
        
        if name == "bold"
        {
            let systemFont = UIFont.systemFont(ofSize: size)
            let font = (CHUtilityFunctions().boldTextSize(size) ?? systemFont).withSize(size)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            //            return UIFontMetrics(forTextStyle: .body).scaledFont(for: OLUtilityFunctions().boldTextSize(size)!)
        }
        else if name == "regular"
        {
            let systemFont = UIFont.systemFont(ofSize: size)
            let font = (CHUtilityFunctions().regularTextSize(size) ?? systemFont).withSize(size)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            //            return UIFontMetrics(forTextStyle: .body).scaledFont(for: OLUtilityFunctions().regularTextSize(size)!)
        }
        else if name == "book"
        {
            let systemFont = UIFont.systemFont(ofSize: size)
            let font = (CHUtilityFunctions().regularBookTextSize(size) ?? systemFont).withSize(size)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            //            return UIFontMetrics(forTextStyle: .body).scaledFont(for: OLUtilityFunctions().regularBookTextSize(size)!)
        }
        else if name == "medium"
        {
            let systemFont = UIFont.systemFont(ofSize: size)
            let font = (CHUtilityFunctions().mediumTextSize(size) ?? systemFont).withSize(size)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            //            return UIFontMetrics(forTextStyle: .body).scaledFont(for: OLUtilityFunctions().mediumTextSize(size)!)
        }
        else if name == "black"
        {
            let systemFont = UIFont.systemFont(ofSize: size)
            let font = (CHUtilityFunctions().blackTextSize(size) ?? systemFont).withSize(size)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            //            return UIFontMetrics(forTextStyle: .body).scaledFont(for: OLUtilityFunctions().blackTextSize(size)!)
        }
        else if name == "semiBold" {
            let systemFont = UIFont.systemFont(ofSize: size)
            let font = (CHUtilityFunctions().mediumTextSize(size) ?? systemFont).withSize(size)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            //            return UIFontMetrics(forTextStyle: .body).scaledFont(for: OLUtilityFunctions().mediumTextSize(size)!)
        }
        else if name == "default"{
            let systemFont = UIFont.systemFont(ofSize: size)
            let font = (CHUtilityFunctions().regularTextSize(size) ?? systemFont).withSize(size)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            //            return OLUtilityFunctions().regularTextSize(size)!
        }
        else
        {
            let systemFont = UIFont.systemFont(ofSize: size)
            let font = (CHUtilityFunctions().lightTextSize(size) ?? systemFont).withSize(size)
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            //return UIFontMetrics(forTextStyle: .body).scaledFont(for: OLUtilityFunctions().lightTextSize(size)!)
            //            return UIFontMetrics( forTextStyle: .body).scaledFont(for: OLUtilityFunctions().lightTextSize(size)!, maximumPointSize: 20)
        }
        
    }
}
