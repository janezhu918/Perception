import UIKit
import Firebase
import FirebaseFirestore
import ProgressHUD

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private var signInMethod: SignInMethod = .logIn
    private enum SignInMethod {
        case logIn
        case register
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
        setupView()
    }
    
    private func setupView() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        loginView.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
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
        ProgressHUD.show()
        switch signInMethod {
        case .logIn:
            print("loging in")
        //TODO: manage login
        case .register:
            print("registering")
            //TODO: manage register
        }
        
    }
    
    

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        logInOrRegister()
        return true
    }
}
