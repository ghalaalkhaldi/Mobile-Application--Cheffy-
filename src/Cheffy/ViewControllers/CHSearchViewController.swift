
import UIKit

// Model for dish
struct Dish {
    let name: String
    let image: UIImage
    let createdBy: String
}

// ViewController for searching dishes
class CHSearchViewController: UIViewController {

    // Arrays to hold dish data
    var arrObjDishes: [CHDishesModel] = [] // Main data array
    var arrfilterDishes = [CHDishesModel]() // Filtered data array for search results
    var arrTempAllDishes = [CHDishesModel]() // Temporary array to hold all dishes
    var isSearch: Bool = false // Flag to indicate if search is active
    
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewHead: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self // Set delegate for search bar
        setupView() // Setup UI
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch all dishes from API
        CHDishesAPIManager().getAllPosts { array, isSuccessfull in
            if isSuccessfull {
                self.arrObjDishes = []
                self.arrObjDishes = array as! [CHDishesModel]
                self.arrfilterDishes = self.arrObjDishes
                self.arrTempAllDishes = self.arrObjDishes
                self.tblSearch.reloadData() // Reload table view with new data
            } else {
                // Show alert if no dishes found
                CHUtilityFunctions().showAlert(message: "No Dish Found. Add New Dishes .", from: self)
            }
        }
    }
    
    // Function to setup UI
    func setupView() {
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        for subView in searchBar.subviews {
            for subView1 in subView.subviews {
                if subView1.isKind(of: UITextField.self) {
                    subView1.backgroundColor = UIColor.clear
                }
            }
        }
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white
            textField.textColor = UIColor.black
            textField.placeholder = "Search Dishes."
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) {
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(1)
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() })
            }
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
        }
    }
}

// Extension for UISearchBarDelegate
extension CHSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            // If search text is empty, show all dishes
            arrfilterDishes = arrObjDishes
            isSearch = false
        } else {
            // Filter dishes based on search text
            arrfilterDishes = arrTempAllDishes.filter {
                ($0.title?.localizedCaseInsensitiveContains(searchText))!
            }
            isSearch = true
        }
        self.tblSearch.reloadData() // Reload table view with filtered data
    }
}

// Extension for UITableViewDelegate and UITableViewDataSource
extension CHSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrfilterDishes.count // Return number of rows based on filtered data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblSearch.dequeueReusableCell(withIdentifier: "CHSearchTableViewCell", for: indexPath) as! CHSearchTableViewCell
        cell.ImgDish.layer.cornerRadius = 10
        let dish = self.arrfilterDishes[indexPath.row]
        let dishImage = dish.selectedImages as! [CHDishImageModel]
        if dishImage.count > 0
        {
            cell.ImgDish.sd_setImage(with: URL(string: dishImage[0].imageUrl ?? ""))
        }
        else
        {
            cell.ImgDish.image = UIImage(named: "Dishes")
        }
        
        cell.lblDishName.text = dish.title
        cell.lblDishCreatedBy.text = dish.postedByName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0 // Set height for each row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
        let vc = (storyboard?.instantiateViewController(withIdentifier: "CHDishDetailViewController") as? CHDishDetailViewController)!
        vc.objDish = self.arrfilterDishes[indexPath.item]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true) // Push to detail view controller
    }
}
