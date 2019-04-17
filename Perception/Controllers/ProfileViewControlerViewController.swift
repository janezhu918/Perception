import UIKit
import FirebaseAuth


class ProfileViewControlerViewController: UIViewController {
    
    let profileView = ProfileView()
    private var ussersession = AppDelegate.authservice
    

    override func viewDidLoad() {
        super.viewDidLoad()
         view.addSubview(profileView)
        profileView.nameTextField.delegate = self
    //    ussersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        ussersession.authserviceSignOutDelegate = self
        setupUI()
        
        guard let user = ussersession.getCurrentUser() else {
            profileView.userEmail.text = "no logged user"
            return
        }
        
        profileView.userEmail.text = user.email
        
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = false
   
    }

}
extension ProfileViewControlerViewController: UITextFieldDelegate {
    
}

extension ProfileViewControlerViewController: AuthServiceSignOutDelegate {
    func didSignOutWithError(_ authservice: AuthService, error: Error) {
        print("error")
    }
    
    func didSignOut(_ authservice: AuthService) {
        print("something else ")
    }
    
    
}


