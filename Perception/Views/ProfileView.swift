import UIKit
import Foundation



class ProfileView: UIView {
    
    lazy var imageProfile: UIImageView = {
       var imageProfile = CircularImageView()
        imageProfile.image = #imageLiteral(resourceName: "placeholder")
       
        return imageProfile
    }()
    
    lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.textColor = .black
        return emailLabel
    }()
    
    lazy var userEmailTextField: UITextField = {
        let userEmail = UITextField()
        userEmail.placeholder = "name@name.com"
        userEmail.font = UIFont(name: "Helvetica", size: 20)
        return userEmail
    }()
    
    lazy var userNameLabel: UILabel = {
        let userName = UILabel()
        userName.text = "Name:"
        userName.textColor = .black
        return userName
    }()
    
    lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = "e.g Pancho Villa"
        nameTextField.layer.cornerRadius = 3
        nameTextField.layer.borderWidth = 0.5
        nameTextField.textAlignment = .center
        return nameTextField
    }()
    
    lazy var ageLabel: UILabel = {
        let ageLabel = UILabel()
        ageLabel.text = "Birthday:"
        ageLabel.textColor = .black
        return ageLabel
    }()
    
    lazy var agePicker: UITextField = {
        let agePicker = UITextField()
        agePicker.layer.cornerRadius = 3
        agePicker.layer.borderWidth = 0.5
        agePicker.textAlignment = .center
        agePicker.placeholder = "click to choose"
        
        return agePicker
    }()
    
    lazy var userGender: UILabel = {
       let gender = UILabel()
        gender.text = "Gender(Opt):"
        return gender
    }()
    
    
    public lazy var segmentedControl: UISegmentedControl = {
        let items = ["Female", "Male", "Non-binary"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return sc
    }()
    
    lazy var locationLabel: UILabel = {
       let locationLabel = UILabel()
        locationLabel.text = "Zip Code:"
        return locationLabel
    }()
    
    lazy var userLocationTextField: UITextField = {
        let userLocationTextField = UITextField()
        userLocationTextField.layer.cornerRadius = 3
        userLocationTextField.layer.borderWidth = 0.5
        userLocationTextField.textAlignment = .center
        userLocationTextField.placeholder = "eg. 10010"
        return userLocationTextField
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        addSubview(imageProfile)
        addSubview(emailLabel)
        addSubview(userEmailTextField)
        addSubview(userNameLabel)
        addSubview(nameTextField)
        addSubview(ageLabel)
        addSubview(agePicker)
        addSubview(userGender)
        addSubview(segmentedControl)
        addSubview(locationLabel)
        addSubview(userLocationTextField)
        labelConstrains()
        
        setGradientBackground(colorOne: #colorLiteral(red: 0.1163222715, green: 0.1882246733, blue: 0.319499135, alpha: 1), colorTwo: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))
    }
    
    func labelConstrains() {
        
        imageProfile.translatesAutoresizingMaskIntoConstraints = false
        [imageProfile.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22), imageProfile.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor), imageProfile.widthAnchor.constraint(equalToConstant: 100), imageProfile.heightAnchor.constraint(equalToConstant: 100)].forEach{ $0.isActive = true }
        
//        emailLabel.translatesAutoresizingMaskIntoConstraints = false
//        [emailLabel.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 22), emailLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)].forEach{ $0.isActive = true }
//        
        userEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        [userEmailTextField.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 33), userEmailTextField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)].forEach{ $0.isActive = true }
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        [userNameLabel.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor, constant: 44), userNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        [nameTextField.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor, constant: 44), nameTextField.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 11), nameTextField.widthAnchor.constraint(equalToConstant: 250)].forEach{ $0.isActive = true }
        
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        [ageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 22), ageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        agePicker.translatesAutoresizingMaskIntoConstraints = false
        [agePicker.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 22), agePicker.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 11), agePicker.widthAnchor.constraint(equalToConstant: 230)].forEach{ $0.isActive = true }
        
        userGender.translatesAutoresizingMaskIntoConstraints = false
        [userGender.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 22), userGender.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        [segmentedControl.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 18), segmentedControl.leadingAnchor.constraint(equalTo: userGender.trailingAnchor, constant: 11)].forEach{ $0.isActive = true }
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        [locationLabel.topAnchor.constraint(equalTo: userGender.bottomAnchor, constant: 22), locationLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        userLocationTextField.translatesAutoresizingMaskIntoConstraints = false
        [userLocationTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 22), userLocationTextField.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 11), userLocationTextField.widthAnchor.constraint(equalToConstant: 230)].forEach{ $0.isActive = true }
        
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBDesignable
    class CircularImageView: UIImageView {
        override func layoutSubviews() {
            super.layoutSubviews()
            contentMode = .scaleAspectFill
            layer.cornerRadius = bounds.width / 2.0
            layer.borderColor = UIColor.lightGray.cgColor
            layer.borderWidth = 0.5
            clipsToBounds = true
        }
}
}


