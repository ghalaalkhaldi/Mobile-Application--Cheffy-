
import UIKit

class CHChefCategoriesListViewController: UIViewController {

    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblChefCategory: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    
    let categories: [Category] = [
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension CHChefCategoriesListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHFoodCategoriesTableViewCell", for: indexPath) as! CHFoodCategoriesTableViewCell
        let obj = self.categories[indexPath.row]
        cell.imgFood.image = obj.image
        cell.lblName.text = obj.name
        cell.imgFood.layer.cornerRadius = 15
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) 
    {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHChefPageViewController") as? CHChefPageViewController)!
          vc.selectedCategory = self.categories[indexPath.row].name
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
