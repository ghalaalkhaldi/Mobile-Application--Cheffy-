

import UIKit

class CHSignUpAsViewController: UIViewController {

    @IBOutlet weak var btnResturant: UIButton!
    @IBOutlet weak var btnChef: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnChef.layer.cornerRadius = 15
        self.btnResturant.layer.cornerRadius = 15
    }
    
    @IBAction func btnResturant_Pressed(_ sender: Any) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SignupRestaurantViewController") as? SignupRestaurantViewController {
            vc.userType = "Resturant"
            navigationController?.pushViewController(vc, animated: false)
        } else {
            print("Failed to instantiate SignupPageViewController")
        }
        
    }
    @IBAction func btnChef_Pressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SignupPageViewController") as? SignupPageViewController {
            vc.userType = "Chef"
            navigationController?.pushViewController(vc, animated: false)
        } else {
            print("Failed to instantiate SignupPageViewController")
        }
    }
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
