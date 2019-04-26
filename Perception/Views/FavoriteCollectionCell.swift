

import UIKit
import AVFoundation

class FavoriteCollectionCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
   
    lazy var videoView: VideoView = {
        let savedVideo = VideoView()
        return savedVideo
    }()
  
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Your videos"
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: "orbitron-light", size: 20)
        textLabel.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = #colorLiteral(red: 0.1276455522, green: 0.2034990788, blue: 0.3436715901, alpha: 1)
        addSubview(videoView)
        addSubview(textLabel)
        cellConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func cellConstrains() {
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoView.topAnchor.constraint(equalTo: topAnchor, constant: 11).isActive = true
            videoView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.8).isActive = true
            videoView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
            videoView.centerXAnchor.constraint(equalTo:safeAreaLayoutGuide.centerXAnchor).isActive = true

            textLabel.translatesAutoresizingMaskIntoConstraints = false
            [textLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 8),
             textLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: 10),  textLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11), textLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11)].forEach{ $0.isActive = true }
    }
    
}
