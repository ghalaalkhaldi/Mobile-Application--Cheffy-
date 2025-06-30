
import Foundation
import UIKit

// Structure to hold dish information
struct categoriesDishes {
    let name: String
    let image: UIImage
    let price: String
    let postedBy: String
}

class CHCategoriesDishesPageViewController: UIViewController {

    // Properties
    var selectedCategory = "" // Selected category from previous view
    var arrObjDishes : [CHDishesModel] = [] // Array to hold dish models fetched from API

    // Static data array for dishes
    let dishes: [categoriesDishes] = [
        categoriesDishes(name: "Burger", image: UIImage(named: "dishes 1")!, price: "$10", postedBy: "Chef Luigi"),
        categoriesDishes(name: "Margherita Pizza", image: UIImage(named: "dishes 2")!, price: "$12", postedBy: "Chef Maria"),
        categoriesDishes(name: "Pasta", image: UIImage(named: "dishes 3")!, price: "$15", postedBy: "Chef Antonio"),
        categoriesDishes(name: "Mint margrita", image: UIImage(named: "dishes 4")!, price: "$10", postedBy: "Chef Luigi"),
        categoriesDishes(name: "Loaded Fries", image: UIImage(named: "dishes 5")!, price: "$12", postedBy: "Chef Maria"),
        categoriesDishes(name: "Shuwarma", image: UIImage(named: "dishes 6")!, price: "$15", postedBy: "Chef Antonio"),
        // Add more dishes here as needed
    ]
    
    // Outlets
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var categoriesTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup after loading the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update UI elements with selected category
        print(self.selectedCategory)
        self.lblCategoryName.text = "\(self.selectedCategory) Dishes"
        
        // Fetch dishes for the selected category from API
        CHDishesAPIManager().getCategoryPosts(category: self.selectedCategory) { array, isSuccessfull in
            if isSuccessfull {
                // Update dish array and reload table view
                if array?.count ?? 0 > 0
                {
                    self.arrObjDishes = array as! [CHDishesModel]
                    self.categoriesTblView.reloadData()
                }
                else
                {
                    self.arrObjDishes = []
                    CHUtilityFunctions().showAlert(message: "No Dish Found under this Cuisine.", from: self)
                }
            } else {
                // Show alert if no dishes found
                self.arrObjDishes = []
                CHUtilityFunctions().showAlert(message: "No Dish Found under this Cuisine.", from: self)
            }
        }
    }
    
    // Back button action
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CHCategoriesDishesPageViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrObjDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHCategoriesTableViewCell", for: indexPath) as! CHCategoriesTableViewCell
        
        // Configure cell with dish information
        let dish = arrObjDishes[indexPath.row]
        let dishImages = dish.selectedImages as! [CHDishImageModel]
        cell.categoriesDishesName.text = dish.title
        if dishImages.count > 0
        {
            cell.categoriesImageViewCell.sd_setImage(with: URL(string: dishImages[0].imageUrl ?? ""), placeholderImage: UIImage(named: ""))
        }
        else
        {
            cell.categoriesImageViewCell.image = UIImage(named: "Dishes")
        }
        cell.categoriesImageViewCell.layer.cornerRadius = 10
        cell.categoriesDishesPriceCell.text = dish.price
        cell.categoriesDishesPostedByCell.text  = dish.postedByName ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CHDishDetailViewController") as? CHDishDetailViewController
        vc?.objDish = self.arrObjDishes[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
