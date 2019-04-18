import UIKit
import FirebaseAuth
import FirebaseStorage


class ProfileViewControlerViewController: UIViewController {
    
    let profileView = ProfileView()
    private var ussersession = AppDelegate.authservice
    private var datePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
         view.addSubview(profileView)
        profileView.nameTextField.delegate = self
        ussersession.authserviceSignOutDelegate = self
        setupUI()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        profileView.agePicker.inputView = datePicker
        
       guard let user = ussersession.getCurrentUser() else {
            profileView.userEmailTextField.text = "no logged user"
            return
        }
        let button1 = UIBarButtonItem(title: "Save changes", style: .plain, target: self, action: #selector(savePreferences))
       
        self.navigationItem.rightBarButtonItem  = button1
        profileView.userEmailTextField.text = user.email
         keyboardDismiss()
    }
    
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        profileView.agePicker.text = dateFormatter.string(from: datePicker!.date)
      
    }
    
    @objc func savePreferences() {
        //TODO: guard against the user state
     
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


extension UIViewController {
    func keyboardDismiss() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboardS))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboardS() {
        view.endEditing(true)
    }
}
