

import UIKit
import Firebase
import SDWebImage
import ChatSDK
import ChatSDKFirebase


struct Category {
    let name: String
    let image: UIImage
}

class CHHomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var collectionViewHorizontal: UICollectionView!
    @IBOutlet weak var popularDishesCollectionViewCell: UICollectionView!
    @IBOutlet weak var allDishesCollectionView: UICollectionView!
    
    // MARK: - Properties
    var objCurrentUser = CHUserModel()
    
    
    var categories: [Category] = []
    var arrObjDishes : [CHDishesModel] = []
    var arrObjPopularDishes : [CHDishesModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //        print("items ==",self.tabBarController?.tabBar.items!)
        //
        //        let tabToChange  = 2
        //        let viewCon = tabBarController?.viewControllers?[tabToChange]
        //
        //        viewCon?.tabBarItem.title = "messge"
        
        collectionViewHorizontal.dataSource = self
        collectionViewHorizontal.delegate = self
        collectionViewHorizontal.backgroundColor = CHStringConstants.Colors.backGroundColor
        if let layout = collectionViewHorizontal.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.scrollDirection = .horizontal
            
        }
        if let layout = popularDishesCollectionViewCell.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.scrollDirection = .horizontal
        }
        if let layout = allDishesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.scrollDirection = .horizontal
            
        }
        allDishesCollectionView.delegate = self
        allDishesCollectionView.dataSource = self
        popularDishesCollectionViewCell.dataSource = self
        popularDishesCollectionViewCell.delegate = self
        popularDishesCollectionViewCell.backgroundColor = CHStringConstants.Colors.backGroundColor
        allDishesCollectionView.backgroundColor = CHStringConstants.Colors.backGroundColor
        _ = BChatSDK.auth()?.authenticate().thenOnMain({ success -> Any? in
            
            return nil
        }, nil)
        BChatSDK.currentUser()?.setEntityID(Auth.auth().currentUser?.uid ?? "")
        BChatSDK.core().setUserOnline()
        viewHeader.roundCorners([.bottomLeft,.bottomRight], radius: 40.0)
       
    }
    
    // MARK: - View Lifecycle
    
    // Refresh view when it appears
    override func viewWillAppear(_ animated: Bool)
    {
        // Show tab bar
        tabBarController?.tabBar.isHidden = false
        // Get user profile
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid ?? "") { array, isSuccessfull in
            if isSuccessfull
            {
                self.objCurrentUser = array![0] as! CHUserModel
                
                if self.objCurrentUser.userType == "Resturant"
                {
                    let tabToChange  = 2
                    let viewCon = self.tabBarController?.viewControllers?[tabToChange]
                    
                    viewCon?.tabBarItem.title = "Chat"
                    viewCon?.tabBarItem.image = UIImage(systemName: "message")
                    viewCon?.tabBarItem.selectedImage = UIImage(systemName: "message")
                    
                    let tabToFourth = 3
                    let viewFourth = self.tabBarController?.viewControllers?[tabToFourth]
                    
                    viewFourth?.tabBarItem.title = "Chef"
                    viewFourth?.tabBarItem.image = UIImage(systemName: "fork.knife")
                    viewFourth?.tabBarItem.selectedImage = UIImage(systemName: "fork.knife")
                    
                    self.categories = [ Category(name: "Food", image: UIImage(named: "Arabic")!),
                                        Category(name: "Chef", image: UIImage(named: "Chef")!)]
                    self.collectionViewHorizontal.reloadData()
                }
                else
                {
                    let tabToChange  = 2
                    let viewCon = self.tabBarController?.viewControllers?[tabToChange]
                    
                    viewCon?.tabBarItem.title = "Add"
                    viewCon?.tabBarItem.image = UIImage(systemName: "plus")
                    viewCon?.tabBarItem.selectedImage = UIImage(systemName: "plus")
                    
                    let tabToFourth  = 3
                    let viewFourth = self.tabBarController?.viewControllers?[tabToFourth]
                    
                    viewFourth?.tabBarItem.title = "Restaurant"
                    viewFourth?.tabBarItem.image = UIImage(systemName: "building")
                    viewFourth?.tabBarItem.selectedImage = UIImage(systemName: "building")
                    
                    self.categories = [ Category(name: "Food", image: UIImage(named: "Arabic")!),Category(name: "Resturants", image: UIImage(named: "Resturants")!)]
                    self.collectionViewHorizontal.reloadData()
                }

                print(self.objCurrentUser.firstName ?? "")
                print(self.objCurrentUser.lastName ?? "")
                
                // Set up current user's image and name for Chat SDK
                BChatSDK.currentUser()?.setImageURL( self.objCurrentUser.profilePic ?? "")
                BChatSDK.currentUser()?.setName("\(self.objCurrentUser.firstName ?? "") \(self.objCurrentUser.lastName ?? "")")
                
                // Get all posts
                CHDishesAPIManager().getAllPosts { array, isSuccessfull in
                    if isSuccessfull {
                        self.arrObjDishes = []
                        self.arrObjDishes = array as! [CHDishesModel]
                        let dishesWithAverageRatings = self.arrObjDishes.map { dish in
                            (dish: dish, averageRating: self.averageRating(for: dish.arrRatings as! [CHDishRatingModel]))
                        }
                        let sortedDishes = dishesWithAverageRatings.sorted { $0.averageRating > $1.averageRating }
                        
                        // Filter dishes with average rating more than 3
                        let top5Dishes = sortedDishes.filter { $0.averageRating > 3 }.prefix(5)
                        
                        // Get the top 5 dishes
                        self.arrObjPopularDishes = []
                        for (dish, averageRating) in top5Dishes {
                            print("\(dish.title ?? ""): \(averageRating)")
                            self.arrObjPopularDishes.append(dish)
                        }
                        self.popularDishesCollectionViewCell.reloadData()
                        self.allDishesCollectionView.reloadData()
                    } else {
                        self.arrObjDishes = []
                        self.arrObjPopularDishes = []
                        self.popularDishesCollectionViewCell.reloadData()
                        self.allDishesCollectionView.reloadData()
                        CHUtilityFunctions().showAlert(message: "No Dish Found. Add New Dishes.", from: self)
                    }
                }

            }
            else
            {
                print("Profile Not Found")
            }
        }
    }
    
    // MARK: - Actions
    
    // Action when chat button is pressed
    @IBAction func btnChat_Pressed(_ sender: Any) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "CHMessagesViewController") as? CHMessagesViewController)!
        vc.hidesBottomBarWhenPushed = true
        vc.isFromChatButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func averageRating(for ratings: [CHDishRatingModel]) -> Int {
        let totalRating = ratings.reduce(0) { $0 + ($1.rating ?? 0) }
        return ratings.isEmpty ? 0 : totalRating / ratings.count
    }
    
    
}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension CHHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0
        {
            return categories.count
        }
        else if collectionView.tag == 1
        {
            return arrObjPopularDishes.count
        }
        else
        {
            return arrObjDishes.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            // Configure cell for categories collection view
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
            let category = categories[indexPath.item]
            cell.categoriesImage.image = category.image
            cell.categoriesName.text = category.name
            return cell
            
        }
        else if collectionView.tag == 1 {
            // Configure cell for popular dishes collection view
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularDishesCollectionViewCell", for: indexPath) as! PopularDishesCollectionViewCell
            cell.popularDishesImages.layer.cornerRadius = 10
            cell.popularDishesImages.layer.masksToBounds = true
            let dish = arrObjPopularDishes[indexPath.item]
            cell.lblCheifName.text = dish.postedByName
            let dishImages = dish.selectedImages as! [CHDishImageModel]
           if dishImages.count > 0
            {
               cell.popularDishesImages.sd_setImage(with: URL(string: dishImages[0].imageUrl ?? ""), placeholderImage: UIImage(named: "Dishes"))
           }
            else
            {
                cell.popularDishesImages.image = UIImage(named: "Dishes")
            }
            cell.popularDishesName.text = dish.title ?? ""
            let arrRatings = dish.arrRatings as! [CHDishRatingModel]
            cell.lblRating.text = "\(self.averageRatingForOne(for: arrRatings))/5"
            return cell
        }
        else if collectionView.tag == 2 {
            // Configure cell for all dishes collection view
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllDishesCollectionView", for: indexPath) as! AllDishesCollectionView
            cell.allDishesImages.layer.cornerRadius = 10
            cell.allDishesImages.layer.masksToBounds = true
            let dish = arrObjDishes[indexPath.item]
            let dishImages = dish.selectedImages as! [CHDishImageModel]
            cell.lblCheifName.text = dish.postedByName
            if dishImages.count > 0
            {
                cell.allDishesImages.sd_setImage(with: URL(string: dishImages[0].imageUrl ?? ""), placeholderImage: UIImage(named: "Dishes"))
            }
            else
            {
                cell.allDishesImages.image = UIImage(named: "Dishes")
            }
            cell.allDishesText.text = dish.title ?? ""
            let arrRatings = dish.arrRatings as! [CHDishRatingModel]
            cell.lblRating.text = "\(self.averageRatingForOne(for: arrRatings))/5"
            return cell
        }
        else{
            fatalError("Unexpected collection view")
        }
        
    }
    func averageRatingForOne(for ratings: [CHDishRatingModel]) -> Int {
        let totalRating = ratings.reduce(0) { $0 + ($1.rating ?? 0) }
        return ratings.isEmpty ? 0 : (totalRating) / (ratings.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.item)
        if collectionView == self.collectionViewHorizontal
        {
            if self.objCurrentUser.userType == "Resturant"
            {
                if indexPath.item == 0
                {
                    let vc = (storyboard?.instantiateViewController(withIdentifier: "CHFoodCategoriesListViewController") as? CHFoodCategoriesListViewController)!
                    vc.selectedType = "Food Cuisine"
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    let vc = (storyboard?.instantiateViewController(withIdentifier: "CHChefCategoriesListViewController") as? CHChefCategoriesListViewController)!
                    //vc.selectedType = "Chef Category"
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else
            {
                if indexPath.item == 0
                {
                    let vc = (storyboard?.instantiateViewController(withIdentifier: "CHFoodCategoriesListViewController") as? CHFoodCategoriesListViewController)!
                    vc.selectedType = "Food Cuisine"
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    let vc = (storyboard?.instantiateViewController(withIdentifier: "CHResturantCategoriesListViewController") as? CHResturantCategoriesListViewController)!
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            
        }
        else if collectionView == self.popularDishesCollectionViewCell
        {
            // Navigate to dish detail page for popular dishes
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHDishDetailViewController") as? CHDishDetailViewController)!
            vc.objDish = self.arrObjPopularDishes[indexPath.item]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            // Navigate to dish detail page for all dishes
            
            let vc = (storyboard?.instantiateViewController(withIdentifier: "CHDishDetailViewController") as? CHDishDetailViewController)!
            vc.objDish = self.arrObjDishes[indexPath.item]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Calculate size for popular and all dishes collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.popularDishesCollectionViewCell
        {
            let frameSize = collectionView.frame.size
            return CGSize(width: (frameSize.width/2.2)-10 , height: frameSize.height)
        }
        else if collectionView == self.allDishesCollectionView
        {
            let frameSize = collectionView.frame.size
            return CGSize(width: (frameSize.width/2.2)-10 , height: frameSize.height)
        }
        else
        {
            // Default size for other collection views
            return CGSize(width: 120.0 , height: 80.0)
        }
    }
    
}
