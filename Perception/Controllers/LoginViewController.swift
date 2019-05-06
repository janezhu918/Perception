import UIKit
import Firebase
import FirebaseFirestore
import ProgressHUD

protocol LoginViewControllerDelegate: AnyObject {
    func checkForLoggedUser(_ logged: Bool)
}

class LoginViewController: UIViewController {
    
    //TODO: add a back button
    private var delegate: LoginViewControllerDelegate?
    
    public var showMessage = false
    public var displayMessage = ""
    public var ultimateDestination: Constants.UltimateDestinationEnum = .myVideos
    private var authservice = AppDelegate.authservice
    private let loginView = LoginView()
    private var signInMethod: SignInMethod = .logIn
    private enum SignInMethod {
        case logIn
        case register
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMessage = true
        view.addSubview(loginView)
        loginView.messageLabel.text = displayMessage
        setupView()
        authservice.authserviceExistingAccountDelegate = self
        authservice.authserviceCreateNewAccountDelegate = self
    }
    
    private func setupView() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        loginView.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        loginView.dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        if showMessage {
            loginView.messageView.isHidden = false
            UIView.animate(withDuration: 0.75, delay: 0, options: [], animations: {
                self.loginView.messageView.frame.origin.y += self.view.bounds.height
            }) { (action) in
                UIView.animate(withDuration: 0, delay: 8, options: [], animations: {
                    self.loginView.messageView.alpha = 0
                }, completion: nil)
            }
        }
    }
    
    @objc private func dismissButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginView.button.setTitle("Log In", for: .normal)
            signInMethod = .logIn
        } else {
            loginView.button.setTitle("Register", for: .normal)
            signInMethod = .register
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        logInOrRegister()
        sender.isEnabled = true
    }
    
    private func logInOrRegister() {
        guard let email = loginView.emailTextField.text, let password = loginView.passwordTextField.text else {
            showAlert(title: "Error", message: "Email and password fields cannot be empty.")
            return
        }
        
        switch signInMethod {
        case .logIn:
          authservice.signInExistingAccount(email: email, password: password)
        case .register:
            authservice.createNewAccount(email: email, password: password)
        }
        delegate?.checkForLoggedUser(true)
        
        //        switch ultimateDestination {
        //        case .myProfile:
        //            dismissButtonPressed()
        //            //TODO: send user to corresponding destination
        //            print("segues to my profile")
        //        case .myVideos:
        //            dismissButtonPressed()
        //            //TODO: send user to corresponding destination
        //            print("segues to my videos")
        //        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        logInOrRegister()
        return true
    }
}

extension LoginViewController: AuthServiceExistingAccountDelegate {
  func didReceiveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
    ProgressHUD.dismiss()
    showAlert(title: "Error", message: error.localizedDescription)
  }
  
  func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
    ProgressHUD.dismiss()
    dismissButtonPressed()
  }
}

extension LoginViewController: AuthServiceCreateNewAccountDelegate {
  func didReceiveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
    ProgressHUD.dismiss()
    showAlert(title: "Error", message: error.localizedDescription)
  }
  
  func didCreateNewAccount(_ authservice: AuthService, perceptionUser: PerceptionUser) {
    ProgressHUD.dismiss()
    dismissButtonPressed()
  }
}
