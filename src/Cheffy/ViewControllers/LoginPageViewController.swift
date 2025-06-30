import UIKit
import SVProgressHUD
import Firebase
import ChatSDK

class LoginPageViewController: UIViewController {
    
    // Outlets for UI elements
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize UI elements
        self.btnLogin.layer.cornerRadius = 10
        self.btnSignUp.layer.cornerRadius = 10
        self.passwordText.isSecureTextEntry = true // Hide password characters
        self.passwordText.delegate = self // Set delegate for password field
    }
    
    // Action when the login button is pressed
    @IBAction func btnLogin_pressed(_ sender: Any) {
        // Validate password format
        if self.validatePassword(self.passwordText.text ?? "") {
            // Validate email format
            if emailText.text?.isEmailValid == true {
                // Show loading indicator
                SVProgressHUD.show()
                
                // Attempt login via email using Firebase authentication
                //Call a function to handle the login process using Firebase. The closure captures the result.
                CHAccountsAPIManager().loginViaEmail(withEmail: self.emailText.text, password: self.passwordText.text) { message, isSuccessfull in
                    if isSuccessfull { // Check if the login was successful.
                        SVProgressHUD.dismiss() // Hide the loading indicator.
                        let currentUser = Auth.auth().currentUser //Get the current authenticated Firebase user
                        
                        // Check if email is verified
                        if currentUser?.isEmailVerified == false {
                            // Show alert for unverified email
                            // Provide options to resend verification email or cancel
                            self.showEmailVerificationAlert() // If the email is not verified, display an alert to the user.
                        } else {
                            // Authenticate with ChatSDK
//                            _ = BChatSDK.auth()?.authenticate().thenOnMain({ success -> Any? in
//                                return nil
//                            }, nil)
                            
                            // Navigate to the main app screen (CHTabBarViewController)
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CHTabBarViewController") as! CHTabBarViewController
                            
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    } else {
                        // Show error message if login fails
                        SVProgressHUD.dismiss()
                        CHUtilityFunctions().showAlert(message: message ?? "ERROR", from: self)
                    }
                }
            } else {
                // Show alert for invalid email format
                self.showInvalidEmailAlert()
            }
        } else {
            // Show alert for invalid password format
            self.showInvalidPasswordAlert()
        }
    }
    
    // Action when signup button is pressed
    @IBAction func signupBtn(_ sender: UIButton) {
        // Navigate to the signup page (SignupPageViewController)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CHSignUpAsViewController") as? CHSignUpAsViewController 
        {
            navigationController?.pushViewController(vc, animated: false)
        } 
        else
        {
            print("Failed to instantiate SignupPageViewController")
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when return key is pressed
        textField.resignFirstResponder()
        return true
    }
    
    // Function to validate the password format
    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex) //a tool for filtering or evaluating expressions.
        //The format string SELF MATCHES %@ means "the input string (SELF) should match the pattern in passwordRegex."
        return passwordPredicate.evaluate(with: password) //This line tests the input password against the predicate (i.e., the regex).
        //It returns true if the password matches the regex (and thus meets the validation criteria) and false otherwise.
    }
    
    // Function to show an alert for invalid email format
    func showInvalidEmailAlert() {
        let dialogMessage = UIAlertController(title: "Alert", message: "Email format is invalid or empty", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // Function to show an alert for invalid password format
    func showInvalidPasswordAlert() {
        let alertMessage = "Password is not valid. Password must contain one capital letter, one special character, and password length should be at least 8 characters."
        CHUtilityFunctions().showAlert(message: alertMessage, from: self)
    }
    
    // Function to show an alert for unverified email
    func showEmailVerificationAlert() {
        let alert = UIAlertController(title: "Warning", message: "Please verify your email first", preferredStyle: .alert)
        
        // Resend verification email action
        let resendAction = UIAlertAction(title: "Resend", style: .default) { _ in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                if error == nil {
                    CHUtilityFunctions().showAlert(message: "Verification email sent", from: self)
                } else {
                    CHUtilityFunctions().showAlert(message: "\(error!)", from: self)
                    print(error?.localizedDescription ?? "Unknown error")
                }
            })
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        // Add actions to the alert
        alert.addAction(resendAction)
        alert.addAction(cancelAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}
