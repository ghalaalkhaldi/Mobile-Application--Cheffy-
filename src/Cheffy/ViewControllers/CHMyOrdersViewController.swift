import UIKit
import Firebase

// ViewController to handle displaying and managing user's orders
class CHMyOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets connected to storyboard
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblMyOrders: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    // Variables to hold user and order data
    var objCurrentUser: CHUserModel = CHUserModel()
    var arrMyOpenOrders: [CHDishBuyModel] = []
    var arrMyClosedOrders: [CHDishBuyModel] = []
    var arrMyCancelOrders: [CHDishBuyModel] = []
    
    // ViewDidLoad - initial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMyOrders.delegate = self
        self.tblMyOrders.dataSource = self
    }
    
    // ViewWillAppear - loading user orders
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        // Fetch user profile and orders
        CHProfileAPIManager().getUserProfileObserver(userId: Auth.auth().currentUser?.uid) { array, isSuccessfull in
            if isSuccessfull {
                self.arrMyOpenOrders = []
                self.arrMyClosedOrders = []
                self.arrMyCancelOrders = []
                self.objCurrentUser = array?[0] as! CHUserModel
                let temp = self.objCurrentUser.arrDishBuy as! [CHDishBuyModel]
                if temp.count > 0 {
                    for i in temp 
                    {
                        if i.status == "open" || i.status == "preparing" || i.status == "ready"
                        {
                            self.arrMyOpenOrders.append(i)
                        }
                        else if i.status == "closed"
                        {
                            self.arrMyClosedOrders.append(i)
                        }
                        else
                        {
                            self.arrMyCancelOrders.append(i)
                        }
                    }
                    self.tblMyOrders.reloadData()
                } else {
                    self.arrMyOpenOrders = []
                    self.arrMyClosedOrders = []
                    self.arrMyCancelOrders = []
                    self.tblMyOrders.reloadData()
                    CHUtilityFunctions().showAlert(message: "You have never placed an order before.", from: self)
                }
            } else {
                // Handle error
            }
        }
    }
    
    // Action for closing an order
    @objc func btnCloseOrder_pressed(sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to mark this order closed?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let obj = self.arrMyOpenOrders[sender.tag]
            CHDishesAPIManager().markAsClosed(dishId: obj.dishId ?? "", chefId: obj.chefId ?? "")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Action for the segmented control to switch between open and closed orders
    @IBAction func segmentControl_pressed(_ sender: Any) {
        self.tblMyOrders.reloadData()
    }
    
    // Action for the Back button to go back to the previous screen
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // TableView DataSource method to set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if segmentControl.selectedSegmentIndex == 0
        {
            return self.arrMyOpenOrders.count
        }
        else if segmentControl.selectedSegmentIndex == 1
        {
            return self.arrMyClosedOrders.count
        }
        else
        {
            return self.arrMyCancelOrders.count
        }
    }
    
    // TableView DataSource method to configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblMyOrders.dequeueReusableCell(withIdentifier: "CHMyOrdersTableViewCell", for: indexPath) as! CHMyOrdersTableViewCell
        let obj: CHDishBuyModel
        
        if segmentControl.selectedSegmentIndex == 0 
        {
            obj = self.arrMyOpenOrders[indexPath.row]
            cell.btnCloseOrder.tag = indexPath.row
            cell.btnCloseOrder.addTarget(self, action: #selector(self.btnCloseOrder_pressed(sender:)), for: .touchUpInside)
            if obj.status == "open"
            {
                cell.btnCloseOrder.isHidden = true
                cell.lblWaitForChefResponse.isHidden = false
                cell.lblOrderIsBeingPrepared.isHidden = true
            }
            else if obj.status == "preparing"
            {
                cell.btnCloseOrder.isHidden = true
                cell.lblWaitForChefResponse.isHidden = true
                cell.lblOrderIsBeingPrepared.isHidden = false
            }
            else if obj.status == "ready"
            {
                cell.btnCloseOrder.isHidden = false
                cell.lblWaitForChefResponse.isHidden = true
                cell.lblOrderIsBeingPrepared.isHidden = true
            }
        }
        else if segmentControl.selectedSegmentIndex == 1 
        {
            obj = self.arrMyClosedOrders[indexPath.row]
            cell.btnCloseOrder.isHidden = true
            cell.lblWaitForChefResponse.isHidden = true
            cell.lblOrderIsBeingPrepared.isHidden = true
        }
        else
        {
            obj = self.arrMyCancelOrders[indexPath.row]
            cell.btnCloseOrder.isHidden = true
            cell.lblWaitForChefResponse.isHidden = true
            cell.lblOrderIsBeingPrepared.isHidden = true
        }
        
        // Configure cell with order details
        cell.ImgDish.sd_setImage(with: URL(string: obj.dishImage ?? ""), placeholderImage: UIImage(named: "Dishes"))
        cell.lblDishName.text = "Dish Name: \(obj.dishName ?? "")"
        cell.lblDishPrice.text = "Price: \(obj.dishPrice ?? "")"
        cell.lblDishCategory.text = "Cuisine: \(obj.dishCategory ?? "")"
        cell.ImgDish.layer.cornerRadius = 10
        cell.btnCloseOrder.layer.cornerRadius = 10
        
        if let timestampMillis = obj.timestamp {
            // Convert milliseconds to seconds
            let timestampSeconds = TimeInterval(timestampMillis) / 1000.0
            let date = Date(timeIntervalSince1970: timestampSeconds)
            
            // Format and display date
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/YY"
            cell.lblDate.text = "Date: \(outputFormatter.string(from: date))"
        } else {
            cell.lblDate.text = "No Date"
        }
        
        return cell
    }
    
    // TableView Delegate method to set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175.0
    }
    
    // TableView Delegate method to handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var objChef = CHUserModel()
        var objDish = CHDishesModel()
        let obj: CHDishBuyModel
        
        if segmentControl.selectedSegmentIndex == 0 {
            obj = self.arrMyOpenOrders[indexPath.row]
        } else if segmentControl.selectedSegmentIndex == 1 {
            obj = self.arrMyClosedOrders[indexPath.row]
        }
        else
        {
            obj = self.arrMyCancelOrders[indexPath.row]
        }
        
        // Fetch dish and chef details
        CHDishesAPIManager().getAllPosts { array, isSuccessfull in
            if isSuccessfull {
                let arr = array as! [CHDishesModel]
                for i in arr {
                    if i.id == obj.dishId {
                        objDish = i
                    }
                }
                
                CHProfileAPIManager().getUserProfile(userId: obj.chefId) { array2, isSuccessfull in
                    if isSuccessfull {
                        objChef = array2![0] as! CHUserModel
                        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CHPlaceOrderViewController") as? CHPlaceOrderViewController)!
                        vc.hidesBottomBarWhenPushed = true
                        vc.objDish = objDish
                        vc.objCheif = objChef
                        vc.isFromOrder = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
