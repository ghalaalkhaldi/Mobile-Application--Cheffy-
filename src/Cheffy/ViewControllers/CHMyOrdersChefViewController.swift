
import UIKit
import Firebase
class CHMyOrdersChefViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var objCurrentUser: CHUserModel = CHUserModel()
    var arrMyOpenOrders: [CHDishBuyModel] = []
    var arrMyClosedOrders: [CHDishBuyModel] = []
    var arrMyCancelOrders: [CHDishBuyModel] = []
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        self.tblOrders.delegate = self
        self.tblOrders.dataSource = self
    }
    
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
                    for i in temp {
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
                    self.tblOrders.reloadData()
                } 
                else
                {
                    self.arrMyOpenOrders = []
                    self.arrMyClosedOrders = []
                    self.arrMyCancelOrders = []
                    self.tblOrders.reloadData()
                    CHUtilityFunctions().showAlert(message: "You have never had an order before.", from: self)
                }
            } 
            else 
            {
                // Handle error
            }
        }
    }
    
    @IBAction func segmentControl_Pressed(_ sender: Any)
    {
        self.tblOrders.reloadData()
    }
    
    @IBAction func btnback_pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCancelOrder_pressed(sender: UIButton) 
    {
        let alert = UIAlertController(title: "Are you sure you want to cancel this order ?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let obj = self.arrMyOpenOrders[sender.tag]
            CHDishesAPIManager().markAsCancel(dishId: obj.dishId ?? "", chefId: obj.userId ?? "")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func btnPrepareOrder_pressed(sender: UIButton) {
        let obj = self.arrMyOpenOrders[sender.tag]
        CHDishesAPIManager().markAsPreparing(dishId: obj.dishId ?? "", chefId: obj.userId ?? "")
       
        
    }
    
    @objc func btnOrderReady_pressed(sender: UIButton) {
        let obj = self.arrMyOpenOrders[sender.tag]
        CHDishesAPIManager().markAsReady(dishId: obj.dishId ?? "", chefId: obj.userId ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let cell = self.tblOrders.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CHMyOrdersChefTableViewCell
            cell.btnOrderReady.isHidden = true
            self.arrMyOpenOrders[sender.tag].status = ""
            self.tblOrders.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
        
       
        
    }
    
 

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return self.arrMyOpenOrders.count
        } else if segmentControl.selectedSegmentIndex == 1{
            return self.arrMyClosedOrders.count
        }
        else
        {
            return self.arrMyCancelOrders.count
        }
    }
    
    // TableView DataSource method to configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblOrders.dequeueReusableCell(withIdentifier: "CHMyOrdersChefTableViewCell", for: indexPath) as! CHMyOrdersChefTableViewCell
        
        let obj: CHDishBuyModel
        
        if segmentControl.selectedSegmentIndex == 0 
        {
            obj = self.arrMyOpenOrders[indexPath.row]
            
        }
        else if segmentControl.selectedSegmentIndex == 2
        {
            obj = self.arrMyCancelOrders[indexPath.row]
        }
        else
        {
            obj = self.arrMyClosedOrders[indexPath.row]
           
        }
        if obj.status == "open"
        {
            cell.btnCancel.isHidden = false
            cell.btnPrepare.isHidden = false
            cell.btnPreparing.isHidden = true
            cell.btnOrderReady.isHidden = true
        }
        else if obj.status == "closed"
        {
            cell.btnCancel.isHidden = true
            cell.btnPrepare.isHidden = true
            cell.btnPreparing.isHidden = true
            cell.btnOrderReady.isHidden = true
            
        }
        else if obj.status == "cancel"
        {
            cell.btnCancel.isHidden = true
            cell.btnPrepare.isHidden = true
            cell.btnPreparing.isHidden = true
            cell.btnOrderReady.isHidden = true
        }
        else if obj.status == "preparing"
        {
            cell.btnCancel.isHidden = true
            cell.btnPrepare.isHidden = true
            cell.btnPreparing.isHidden = false
            cell.btnOrderReady.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                cell.btnCancel.isHidden = true
                cell.btnPrepare.isHidden = true
                cell.btnPreparing.isHidden = true
                cell.btnOrderReady.isHidden = false
            }
        }
        else if obj.status == "ready"
        {
            cell.btnCancel.isHidden = true
            cell.btnPrepare.isHidden = true
            cell.btnPreparing.isHidden = true
            cell.btnOrderReady.isHidden = false
        }
        else if obj.status == ""
        {
            cell.btnCancel.isHidden = true
            cell.btnPrepare.isHidden = true
            cell.btnPreparing.isHidden = true
            cell.btnOrderReady.isHidden = true
        }
        
        
        // Configure cell with order details
        cell.imgDish.sd_setImage(with: URL(string: obj.dishImage ?? ""), placeholderImage: UIImage(named: "Dishes"))
        cell.lblDishName.text = "Dish Name: \(obj.dishName ?? "")"
        cell.lblDishPrice.text = "Price: \(obj.dishPrice ?? "")"
        cell.lblDishCategory.text = "Cuisine: \(obj.dishCategory ?? "")"
        
        cell.imgDish.layer.cornerRadius = 10
        cell.btnCancel.layer.cornerRadius = 10
        cell.btnPrepare.layer.cornerRadius = 10
        cell.btnPreparing.layer.cornerRadius = 10
        cell.btnOrderReady.layer.cornerRadius = 10
        
        cell.btnCancel.tag = indexPath.row
        
        cell.btnPrepare.tag = indexPath.row
        
        cell.btnOrderReady.tag = indexPath.row
        
        cell.btnCancel.addTarget(self, action: #selector(btnCancelOrder_pressed(sender:)), for: .touchUpInside)
        
        cell.btnPrepare.addTarget(self, action: #selector(btnPrepareOrder_pressed(sender:)), for: .touchUpInside)
        
        cell.btnOrderReady.addTarget(self, action: #selector(btnOrderReady_pressed(sender:)), for: .touchUpInside)
        
        if let timestampMillis = obj.timestamp {
            // Convert milliseconds to seconds
            let timestampSeconds = TimeInterval(timestampMillis) / 1000.0
            let date = Date(timeIntervalSince1970: timestampSeconds)
            
            // Format and display date
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/YY"
            cell.lblDishTimestamp.text = "Date: \(outputFormatter.string(from: date))"
        } else {
            cell.lblDishTimestamp.text = "No Date"
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
            
        }else if segmentControl.selectedSegmentIndex == 2
        {
            obj = self.arrMyCancelOrders[indexPath.row]
        }else {
            obj = self.arrMyClosedOrders[indexPath.row]
           
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
