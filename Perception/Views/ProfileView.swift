import UIKit
import Foundation



class ProfileView: UIView {
    
    lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email:"
        emailLabel.textColor = .black
        return emailLabel
    }()
    
    lazy var userEmail: UITextField = {
        let userEmail = UITextField()
        userEmail.placeholder = "name@name.com"
        return userEmail
    }()
    
    lazy var userNane: UILabel = {
        let userName = UILabel()
        userName.text = "Name:"
        userName.textColor = .black
        return userName
    }()
    
    lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = "e.g Pancho Villa"
        return nameTextField
    }()
    
    let ageLabel: UILabel = {
        let ageLabel = UILabel()
        ageLabel.text = "Age:"
        ageLabel.textColor = .black
        return ageLabel
    }()
    
    let agePicker: UIDatePicker = {
        let agePicker = UIDatePicker()
        return agePicker
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        backgroundColor = .white
        addSubview(emailLabel)
        addSubview(userEmail)
        addSubview(userNane)
        addSubview(nameTextField)
        addSubview(ageLabel)
       // addSubview(agePicker)
        labelConstrains()
    }
    
    func labelConstrains() {
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        [emailLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22), emailLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        [userEmail.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22), userEmail.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 11)].forEach{ $0.isActive = true }
        
        userNane.translatesAutoresizingMaskIntoConstraints = false
        [userNane.topAnchor.constraint(equalTo: userEmail.bottomAnchor, constant: 22), userNane.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        [nameTextField.topAnchor.constraint(equalTo: userEmail.bottomAnchor, constant: 22), nameTextField.leadingAnchor.constraint(equalTo: userNane.trailingAnchor, constant: 11)].forEach{ $0.isActive = true }
        
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        [ageLabel.topAnchor.constraint(equalTo: userNane.bottomAnchor, constant: 22), ageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        agePicker.translatesAutoresizingMaskIntoConstraints = false
        [agePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 22), agePicker.leadingAnchor.constraint(equalTo: agePicker.trailingAnchor, constant: 11)]
        
    }
}

