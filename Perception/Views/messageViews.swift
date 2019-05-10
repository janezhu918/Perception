import Foundation
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
        addSubview(alertView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(buttonScape)
        addSubview(msgButton)
        setConstrains()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstrains() {
        
        //        doubleTapView.translatesAutoresizingMaskIntoConstraints = false
        //        [doubleTapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 33), doubleTapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 88), doubleTapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -88), doubleTapView.bottomAnchor.constraint(equalTo: alertView.topAnchor, constant: -70)].forEach{ $0.isActive = true }
        //
        //        doubleTapMessage.translatesAutoresizingMaskIntoConstraints = false
        //        [doubleTapMessage.topAnchor.constraint(equalTo: doubleTapView.topAnchor, constant: 11), doubleTapMessage.bottomAnchor.constraint(equalTo: doubleTapView.bottomAnchor, constant: -22), doubleTapMessage.leadingAnchor.constraint(equalTo: doubleTapView.leadingAnchor, constant: 22), doubleTapMessage.trailingAnchor.constraint(equalTo: doubleTapView.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        //
        alertView.translatesAutoresizingMaskIntoConstraints = false
        [alertView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 170), alertView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -200), alertView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 88), alertView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -88)].forEach{ $0.isActive = true }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        [titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 44), titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 22), titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        [messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44), messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 22), messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
        buttonScape.translatesAutoresizingMaskIntoConstraints = false
        [buttonScape.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 44), buttonScape.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 22), buttonScape.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -22)].forEach{ $0.isActive = true }
        
        
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
