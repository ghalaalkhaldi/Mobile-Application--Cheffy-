
import UIKit
import Firebase

class CHFoodCategoriesListViewController: UIViewController {
    
    @IBOutlet weak var tblCategory: UITableView!  //A table view to display the list of categories.
    @IBOutlet weak var lblFoodCategory: UILabel! //A label to display the title of the screen (potentially).
    @IBOutlet weak var btnBack: UIButton! //A button for navigating back.
    @IBOutlet weak var viewHeader: UIView! //The container view for the header elements.
    
    let categories: [Category] = [ //An array of Category objects, each containing a name and image representing a food category.
        Category(name: "Arabic", image: UIImage(named: "Arabic")!),
        Category(name: "Chinese", image: UIImage(named: "Chinese")!),
        Category(name: "French", image: UIImage(named: "French")!),
        Category(name: "Indian", image: UIImage(named: "Indian")!),
        Category(name: "Japanese", image: UIImage(named: "Japanese")!),
        Category(name: "Lebanese", image: UIImage(named: "Lebanese")!),
        Category(name: "Mexican", image: UIImage(named: "Mexican")!),
        Category(name: "Pakistani", image: UIImage(named: "Pakistani")!),
        Category(name: "Spanish", image: UIImage(named: "Spanish")!),
        Category(name: "Thai", image: UIImage(named: "Thai")!),
    ]
    var selectedType = "" //A string that might be used to filter categories.
    
    override func viewDidLoad() { //called when the view controller's view is loaded into memory
        super.viewDidLoad()
        //self.lblFoodCategory.text = selectedType
    }
    
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension CHFoodCategoriesListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count // Return the number of food categories to display
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a reusable cell (custom CHFoodCategoriesTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHFoodCategoriesTableViewCell", for: indexPath) as! CHFoodCategoriesTableViewCell
        // Get the category object for the current row
        let obj = self.categories[indexPath.row]
        
        //Configure the cell's image, name, and image styling
        cell.imgFood.image = obj.image
        cell.lblName.text = obj.name
        cell.imgFood.layer.cornerRadius = 15 //Rounded corners for the image
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0 //Set a fixed height of 100 points for each cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Instantiate the next view controller
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHCategoriesDishesPageViewController") as? CHCategoriesDishesPageViewController)!
        //2. Pass data to the next view controller
            vc.selectedCategory = self.categories[indexPath.row].name
        // 3. Hide tab bar in the next view controller
            vc.hidesBottomBarWhenPushed = true
        // 4. Navigate to the next view controller
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
