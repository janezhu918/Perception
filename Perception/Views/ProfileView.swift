import UIKit
import Foundation



class ProfileView: UIView {
    
    lazy var imageProfile: UIImageView = {
        var imageProfile = CircularImageView()
        imageProfile.image = #imageLiteral(resourceName: "placeholder")
        imageProfile.contentMode = .scaleAspectFit
        return imageProfile
    }()
    
    lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return emailLabel
    }()
    
    lazy var userEmailTextField: UITextField = {
        let userEmail = UITextField()
        
        userEmail.font = UIFont(name: "Helvetica", size: 24)
        userEmail.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return userEmail
    }()
    
    lazy var userNameLabel: UILabel = {
        let userName = UILabel()
        userName.text = "Name:"
        userName.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return userName
    }()
    
    lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = "e.g Pancho Villa"
        nameTextField.layer.cornerRadius = 3
        nameTextField.layer.borderWidth = 0.5
        nameTextField.textAlignment = .center
        nameTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        nameTextField.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return nameTextField
    }()
    
    lazy var ageLabel: UILabel = {
        let ageLabel = UILabel()
        ageLabel.text = "Birthday:"
        ageLabel.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return ageLabel
    }()
    
    lazy var agePicker: UITextField = {
        let agePicker = UITextField()
        agePicker.layer.cornerRadius = 3
        agePicker.layer.borderWidth = 0.5
        agePicker.textAlignment = .center
        agePicker.layer.borderColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        agePicker.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        agePicker.placeholder = "click to choose"
        
        return agePicker
    }()
    
    lazy var userGender: UILabel = {
        let gender = UILabel()
        gender.text = "Gender:"
        gender.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return gender
    }()
    
    
    public lazy var segmentedControl: UISegmentedControl = {
        let items = ["Female", "Male", "Non-binary"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.tintColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return sc
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "Zip Code:"
        locationLabel.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return locationLabel
    }()
    
    lazy var userLocationTextField: UITextField = {
        let userLocationTextField = UITextField()
        userLocationTextField.layer.cornerRadius = 3
        userLocationTextField.layer.borderWidth = 0.5
        userLocationTextField.textAlignment = .center
        userLocationTextField.placeholder = "eg. 10010"
        userLocationTextField.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        userLocationTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return userLocationTextField
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        
        //            func shouldAutorotate() -> Bool {
        //                return false
        //            }
        
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
        setupConstrains()
        setGradientBackground(colorOne: #colorLiteral(red: 0.1163222715, green: 0.1882246733, blue: 0.319499135, alpha: 1), colorTwo: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), frame: UIScreen.main.bounds)
    }
    
    
    
    func setupConstrains() {
        
        imageProfile.translatesAutoresizingMaskIntoConstraints = false
        [imageProfile.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22), imageProfile.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor), imageProfile.widthAnchor.constraint(equalToConstant: 100), imageProfile.heightAnchor.constraint(equalToConstant: 100)].forEach{ $0.isActive = true }
        
        
        
        userEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        [userEmailTextField.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 33), userEmailTextField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)].forEach{ $0.isActive = true }
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        [userNameLabel.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor, constant: 44), userNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22) ].forEach{ $0.isActive = true }
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        [nameTextField.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor, constant: 44), nameTextField.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 11), nameTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -22), nameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)].forEach{ $0.isActive = true }
        
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        [ageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 22), ageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        agePicker.translatesAutoresizingMaskIntoConstraints = false
        [agePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 22), agePicker.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 11), agePicker.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
        userGender.translatesAutoresizingMaskIntoConstraints = false
        [userGender.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 22), userGender.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        [segmentedControl.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 18), segmentedControl.leadingAnchor.constraint(equalTo: userGender.trailingAnchor, constant: 11), segmentedControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        [locationLabel.topAnchor.constraint(equalTo: userGender.bottomAnchor, constant: 22), locationLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 22)].forEach{ $0.isActive = true }
        
        userLocationTextField.translatesAutoresizingMaskIntoConstraints = false
        [userLocationTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 22), userLocationTextField.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 11), userLocationTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = frame
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.3)
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


