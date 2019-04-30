import UIKit
import FirebaseAuth
import FirebaseStorage


class ProfileViewControlerViewController: UIViewController {
    
    
    
    let profileView = ProfileView()
    private var ussersession = AppDelegate.authservice
    private var datePicker: UIDatePicker?
   
    private var currentUser: PerceptionUser!
    

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
        DatabaseService.fetchPerceptionUser(uid: user.uid) { (perceptionUser, error) in
            if let perceptionUser = perceptionUser {
                self.profileView.nameTextField.text = perceptionUser.displayName
            } else if let error = error {
                print("if there's an error is here! \(error.localizedDescription)")
            }
        }
        
        profileView.nameTextField.text = ""
         keyboardDismiss()
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
         AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
  
    override var shouldAutorotate: Bool {
        return false 
    }
    
    
    
   @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        profileView.agePicker.text = dateFormatter.string(from: datePicker!.date)
      
    }
    
    @objc func savePreferences() {
        guard let userName = profileView.nameTextField.text,
            let userID = ussersession.getCurrentUser()?.uid,
            !userName.isEmpty else {
                showAlert(title: "Missing Name", message: "Please add you name")
                return
        }
        DatabaseService.fetchPerceptionUser(uid: userID, completion: { (user, error) in
            if let user = user {
                let userUpdateData = PerceptionUser(userUID: user.userUID, email: user.email, displayName: userName, firstName: "", lastName: "", photoURL: "", gender: "", birthday: "", zipCode: "")
                DatabaseService.updatePerceptionUser(perceptionUser: userUpdateData, completion: { (error) in
                    if let error = error {
                        self.showAlert(title: "Erro saving Data", message: error.localizedDescription)
                        print(error.localizedDescription)
                    }
                    self.showAlert(title: "Succesfully saved", message: "Your profile has been saved", handler: { (alert) in
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        let gobackVC = ViewController()
                        self.present(gobackVC, animated: true, completion: nil)
                    })
                  
                })
            } else if let error = error {
            self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })

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
