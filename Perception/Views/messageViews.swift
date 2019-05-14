import UIKit

class AnimationMessage: UIView {
    
    lazy var doubleTapView: UIView = {
        let doubleTapView = UIView()
        let color = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        doubleTapView.backgroundColor = color
        doubleTapView.backgroundColor = color.withAlphaComponent(0.5)
        doubleTapView.layer.cornerRadius = 10.0
        return doubleTapView
    }()
    
    lazy var doubleTapMessage: UILabel = {
        let doubleTapMessage = UILabel()
        doubleTapMessage.text = "Double tap anywhere to watch full video"
        doubleTapMessage.numberOfLines = 0
        doubleTapMessage.textAlignment = .center
        doubleTapMessage.font = UIFont(name: "HelveticaNeue", size: 14)
        return doubleTapMessage
    }()
    
    lazy var okOndoubleTap: UIButton = {
       let okOndoubleTap = UIButton()
        okOndoubleTap.setTitle("Ok", for: .normal)
        okOndoubleTap.titleLabel?.textColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        okOndoubleTap.titleLabel?.textAlignment = .center
        okOndoubleTap.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        okOndoubleTap.layer.cornerRadius = 8
        okOndoubleTap.layer.borderWidth = 0.5
        okOndoubleTap.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        okOndoubleTap.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1960784314, blue: 0.3176470588, alpha: 1)
        okOndoubleTap.setTitleColor(#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .normal)
        return okOndoubleTap
    }()
    
    lazy var doubleTapNotShow: UIButton = {
       let doubleTapNotShow = UIButton()
        doubleTapNotShow.setTitle("Don't show again", for: .normal)
        doubleTapNotShow.titleLabel?.textColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        doubleTapNotShow.titleLabel?.textAlignment = .center
        doubleTapNotShow.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        doubleTapNotShow.layer.cornerRadius = 8
        doubleTapNotShow.layer.borderWidth = 0.5
        doubleTapNotShow.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        doubleTapNotShow.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1960784314, blue: 0.3176470588, alpha: 1)
        doubleTapNotShow.setTitleColor(#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .normal)
        return doubleTapNotShow
    }()
    
    
    lazy var alertView: UIView = {
        let alertView = UIView()
        let color = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        alertView.backgroundColor = color
        alertView.backgroundColor = color.withAlphaComponent(0.5)
        alertView.layer.cornerRadius = 10.0
        return alertView
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        let image = UIImage(named: "close")
        closeButton.setImage(image, for: .normal)
        return closeButton
    }()
    
    
    lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "Title of the message"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        titleLabel.textColor = #colorLiteral(red: 0.1411764706, green: 0.1960784314, blue: 0.3176470588, alpha: 1)
        return titleLabel
    }()
    
    lazy var messageLabel: UILabel = {
        var messageLabel = UILabel()
        messageLabel.text = "Title of the mesage that takes up more space bla bla, yeah aja Ermis is my baby"
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        messageLabel.textColor = #colorLiteral(red: 0.1411764706, green: 0.1960784314, blue: 0.3176470588, alpha: 1)
        return messageLabel
    }()
    
    lazy var okButton: UIButton = {
        let okButton = UIButton()
        okButton.setTitle("Ok", for: .normal)
        okButton.titleLabel?.textColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        okButton.titleLabel?.textAlignment = .center
        okButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        okButton.layer.cornerRadius = 15
        okButton.layer.borderWidth = 0.5
        okButton.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        okButton.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1960784314, blue: 0.3176470588, alpha: 1)
        okButton.setTitleColor(#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .normal)
        return okButton
    }()
    
    lazy var buttonScape: UIButton = {
        let buttonScape = UIButton()
        buttonScape.setTitle("Don't show again", for: .normal)
        buttonScape.titleLabel?.textColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        buttonScape.titleLabel?.textAlignment = .center
        buttonScape.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        buttonScape.layer.cornerRadius = 15
        buttonScape.layer.borderWidth = 0.5
        buttonScape.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        buttonScape.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1960784314, blue: 0.3176470588, alpha: 1)
        buttonScape.setTitleColor(#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .normal)
        return buttonScape
    }()
    
    
    
    
    lazy var msgButton: UIButton = {
        let msgButton = UIButton()
        msgButton.setTitle("Don't show me this again", for: .normal)
        return msgButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    func commonInit() {
        addSubview(doubleTapView)
        addSubview(doubleTapMessage)
        addSubview(okOndoubleTap)
        addSubview(doubleTapNotShow)
        addSubview(alertView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(okButton)
        addSubview(buttonScape)
        addSubview(msgButton)
        setConstrains()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstrains() {
        
        doubleTapView.translatesAutoresizingMaskIntoConstraints = false
                [doubleTapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 33), doubleTapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 33), doubleTapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -33), doubleTapView.bottomAnchor.constraint(equalTo: alertView.topAnchor, constant: -50)].forEach{ $0.isActive = true }
        
                doubleTapMessage.translatesAutoresizingMaskIntoConstraints = false
                [doubleTapMessage.topAnchor.constraint(equalTo: doubleTapView.topAnchor, constant: 11),  doubleTapMessage.leadingAnchor.constraint(equalTo: doubleTapView.leadingAnchor, constant: 33), doubleTapMessage.trailingAnchor.constraint(equalTo: doubleTapView.trailingAnchor, constant: -33)].forEach{ $0.isActive = true }
        
        okOndoubleTap.translatesAutoresizingMaskIntoConstraints = false
        [okOndoubleTap.topAnchor.constraint(equalTo: doubleTapMessage.bottomAnchor, constant: 11), okOndoubleTap.leadingAnchor.constraint(equalTo: doubleTapMessage.leadingAnchor, constant: 11), okOndoubleTap.trailingAnchor.constraint(equalTo: doubleTapMessage.trailingAnchor, constant: -140), okOndoubleTap.bottomAnchor.constraint(equalTo: doubleTapView.bottomAnchor, constant: -11)].forEach{ $0.isActive = true }
        
        doubleTapNotShow.translatesAutoresizingMaskIntoConstraints = false
        [doubleTapNotShow.topAnchor.constraint(equalTo: doubleTapMessage.bottomAnchor, constant: 11), doubleTapNotShow.leadingAnchor.constraint(equalTo: okOndoubleTap.trailingAnchor, constant: 0), doubleTapNotShow.trailingAnchor.constraint(equalTo: doubleTapMessage.trailingAnchor, constant: -11), doubleTapNotShow.bottomAnchor.constraint(equalTo: doubleTapView.bottomAnchor, constant: -11)].forEach{ $0.isActive = true }
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        [alertView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 170), alertView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -200), alertView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 88), alertView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -88)].forEach{ $0.isActive = true }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        [titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 44), titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 22), titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        [messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44), messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 22), messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
        okButton.translatesAutoresizingMaskIntoConstraints = false
        [okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 44), okButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 22), okButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
        buttonScape.translatesAutoresizingMaskIntoConstraints = false
        [buttonScape.topAnchor.constraint(equalTo: okButton.bottomAnchor, constant: 11), buttonScape.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 22), buttonScape.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
    }
    
}

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
