
import UIKit
import Firebase


class CHMyDIshesViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton! //A button to navigate back to the previous screen.
    @IBOutlet weak var tblDishes: UITableView! //A table view to display the list of dishes.
    @IBOutlet weak var viewHeader: UIView! //A container view for the header elements.
    @IBOutlet weak var viewMain: UIView! //The main container view for the entire screen.
    
    var arrDishes : [CHDishesModel] = [] //an array to hold the CHDishesModel objects representing the chef's dishes.
    
    override func viewDidLoad() { //this view controller will handle the table view's behavior and data population.
        super.viewDidLoad()
        self.tblDishes.delegate = self
        self.tblDishes.dataSource = self

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.arrDishes = [] //Empties the arrDishes array to start fresh.
        CHDishesAPIManager().getAllPosts { array, isSuccessfull in //Calls the getAllPosts method of CHDishesAPIManager to fetch all dish data.
            if isSuccessfull
            {
                    for i in array as! [CHDishesModel] //Iterates through the fetched dishes (array as! [CHDishesModel]).
                    {
                        if i.postedBy == Auth.auth().currentUser?.uid //Checks if the postedBy field of each dish matches the current user's ID.
                        {
                            self.arrDishes.append(i) //If it matches, the dish is added to the arrDishes array.
                            
                        }
                    }
                if self.arrDishes.count > 0 //If there are dishes in the arrDishes array
                {
                    self.tblDishes.reloadData() //it reloads the table view to display them.
                }
                else
                {
                    self.arrDishes = []
                    self.tblDishes.reloadData()
                    CHUtilityFunctions().showAlert(message: "No dish found . Kindly add your dish first .", from: self)
                    //shows an alert message indicating that the chef hasn't added any dishes yet.
                }
                    
            }
            else
            {
                self.arrDishes = []
                self.tblDishes.reloadData()
                
            }
        }
    }
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension CHMyDIshesViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDishes.count //Returns the number of rows (dishes) to display in the table view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configures each table view cell with the dish information
        //(image, name, price, category). It also sets the image
        //view's corner radius for a rounded appearance.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHMyDishesTableViewCell", for: indexPath) as! CHMyDishesTableViewCell
        let obj = self.arrDishes[indexPath.row]
        if obj.selectedImages.count > 0
        {
            let objImage = obj.selectedImages[0] as! CHDishImageModel
            cell.imgDish.sd_setImage(with: URL(string: "\(objImage.imageUrl ?? "")"), placeholderImage: UIImage(named: "Dishes"))
        }
        else
        {
            cell.imgDish.image = UIImage(named: "Dishes")
        }
     
        cell.imgDish.layer.cornerRadius = 10
        cell.lblDishName.text = obj.title ?? ""
        cell.lblDishPrice.text = "Price: \(obj.price ?? "")"
        cell.lblDishCategory.text = "Cuisine : \(obj.category ?? "")"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0 // Sets a fixed height (150.0 points) for each row in the table view.
    }
    
    
}
