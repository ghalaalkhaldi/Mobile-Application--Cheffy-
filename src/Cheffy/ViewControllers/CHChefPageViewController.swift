

import UIKit
import Firebase
import SVProgressHUD

class CHChefPageViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblChefs: UITableView!
    
    
    var selectedCategory = ""
    var arrObjChefTemp : [CHUserModel] = []
    var arrObjChef : [CHUserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        
        CHProfileAPIManager().getAllUsers { array, isSuccessfull in
            if isSuccessfull
            {
                if array?.count ?? 0 > 0
                {
                    self.arrObjChefTemp = array as! [CHUserModel]
                    self.arrObjChef = []
                    for i in self.arrObjChefTemp
                    {
                        if i.userType == "Chef"
                        {
                            if i.category == self.selectedCategory
                            {
                                self.arrObjChef.append(i)
                            }
                        }
                       
                    }
                    self.tblChefs.reloadData()
                    SVProgressHUD.dismiss()
                }
                else
                {
                    SVProgressHUD.dismiss()
                    CHUtilityFunctions().showAlert(message: "No Chef found in selected Cuisine", from: self)
                }
               
            }
            else
            {
                SVProgressHUD.dismiss()
                CHUtilityFunctions().showAlert(message: "No Chef found in selected Cuisine", from: self)
            }
        }
    }
    

    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CHChefPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return self.arrObjChef.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHResturantTableViewCell", for: indexPath) as! CHResturantTableViewCell
        // Configure cell with restaurant information
        cell.resturantImageCell.layer.cornerRadius = 10
        let chef = self.arrObjChef[indexPath.row]
        let chefImage = chef.profilePic
        cell.resturantImageCell.sd_setImage(with: URL(string: chefImage ?? ""),placeholderImage: UIImage(named: "person"))
        cell.resturantName.text = "\(chef.firstName ?? "")\(chef.lastName ?? "")"
        cell.resturantAddress.text = chef.email ?? ""
        cell.resturantContactNo.text = chef.phoneNumber ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CHChefProfileDetailViewController") as? CHChefProfileDetailViewController
        vc?.hidesBottomBarWhenPushed = true
        vc?.objChef = self.arrObjChef[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

