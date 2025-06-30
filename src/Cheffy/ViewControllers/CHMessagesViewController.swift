import UIKit
import ChatSDKFirebase
import FirebaseAuth
import Firebase

class CHMessagesViewController: UIViewController {
    
    // Outlets for UI elements
    @IBOutlet weak var tblMessages: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    // Model object to store current user information
    var objCurrentUser = CHUserModel()
    var isFromChatButton = false
    
    // Array to store chat threads
    var threadsArray : [PThread] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromChatButton
        {
            self.btnBack.isHidden = false
        }
        else
        {
            self.btnBack.isHidden = true
        }
        // Set up table view data source and delegate
        self.tblMessages.dataSource = self
        self.tblMessages.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch current user profile
        self.threadsArray = []
        CHProfileAPIManager().getUserProfile(userId: Auth.auth().currentUser?.uid ?? "") { array, isSuccessfull in
            if isSuccessfull {
                // Update current user information
                self.objCurrentUser = array![0] as! CHUserModel
                print(self.objCurrentUser.firstName ?? "")
                print(self.objCurrentUser.lastName ?? "")
                
                // Fetch chat threads
                let test = BChatSDK.core().threads(with: bThreadType1to1) as! [PThread]
                self.threadsArray.append(contentsOf: test)
                
                print(self.threadsArray.count)
                self.tblMessages.reloadData()
            }
        }
    }
    
    // Function to reload data
    func reloadData() {
        self.threadsArray.removeAll()
        threadsArray =  BChatSDK.core().threads(with: bThreadType1to1, includeDeleted: false) as! [PThread]
        tblMessages.reloadData()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Function to create chat thread from search
    func createChatThreadFromSearch(objThread: PThread) {
        let cvc = BChatSDK.ui().chatViewController(with: objThread)
        cvc?.modalPresentationStyle = .popover
        cvc?.navigationController?.navigationBar.isHidden = false
        cvc?.navigationController?.navigationBar.backgroundColor = .gray
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.present(cvc!, animated: true)
    }
    
    // Function to create chat thread
    func createChatThread(objThread: PThread) {
        let chatViewController = BChatSDK.ui().chatViewController(with:objThread)
        let controller = BChatViewController.init(thread: objThread)
        controller?.updateTitle()
        controller?.doViewWillDisappear(true)
        objThread.markRead()
        chatViewController?.modalPresentationStyle = .popover
        self.present(controller!, animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource

extension CHMessagesViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.threadsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objThread = threadsArray[indexPath.row]
        let cell = self.tblMessages.dequeueReusableCell(withIdentifier:"CHMessageTableViewCell")! as! CHMessageTableViewCell
        cell.populateCell(objThread: objThread)
        cell.viewMain.layer.cornerRadius = 10
        cell.imgProfile.tag = indexPath.row
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        cell.imgProfile.addGestureRecognizer(tapGesture)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objThread = threadsArray[indexPath.row]
        
        objThread.otherUser().entityID()
        objThread.markRead()
        self.createChatThread(objThread: objThread)
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer)
    {
        let objThread = threadsArray[sender.view?.tag ?? 0]
        //objThread.entityID()
        let vc = storyboard?.instantiateViewController(withIdentifier: "CHChefProfileDetailViewController") as? CHChefProfileDetailViewController
        vc?.entityId = objThread.otherUser().entityID()
        vc?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
