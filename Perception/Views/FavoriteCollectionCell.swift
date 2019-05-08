

import UIKit
import AVFoundation

protocol FavoriteCollectionCellDelegate: AnyObject {
    func cellTapped(indexPath: IndexPath)
}

class FavoriteCollectionCell: UICollectionViewCell {
    
    weak var delegate: FavoriteCollectionCellDelegate?
    public var indexPath: IndexPath!
    
    public lazy var imageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    public lazy var expandingButton: UIButton = {
        let expandingButton = UIButton()
        expandingButton.setTitle("↓", for: .normal)
        expandingButton.addTarget(self, action: #selector(expandingButtontapped(_:)), for: .touchUpInside)
        return expandingButton
    }()
    
    public lazy var videoDescriptionLabel: UILabel = {
        let videoDescriptionLabel = UILabel()
//        videoDescriptionLabel.isHidden = true
        videoDescriptionLabel.textColor = Constants.perceptionGrayColor
        videoDescriptionLabel.text = "Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing"
        return videoDescriptionLabel
    }()
    
    @objc public func expandingButtontapped(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.cellTapped(indexPath: indexPath)
        }
    }
    
    public lazy var videoView: VideoView = {
        let videoView = VideoView()
        return videoView
    }()
    
    public lazy var videoTitleLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Your videos"
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    public func commonInit() {
        backgroundColor = Constants.perceptionNavyColor
        addSubview(videoView)
        addSubview(videoTitleLabel)
        addSubview(expandingButton)
        addSubview(videoDescriptionLabel)
        cellConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public func cellConstrains() {
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: -5),
            videoView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            videoView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.66),
            videoView.centerXAnchor.constraint(equalTo:safeAreaLayoutGuide.centerXAnchor)])
        
        videoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            videoTitleLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: 10),
            videoTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11),
            videoTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11)])
        
        expandingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandingButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11),
            expandingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11)])
        
        videoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoDescriptionLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 5),
            videoDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            videoDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
//            videoDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11)
            ])
    }
    
}
