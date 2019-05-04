

import UIKit
import AVFoundation

enum ExpandSize: CaseIterable {
  case expanded
  case contracted
}

class FavoriteCollectionCell: UICollectionViewCell {
  
  private var sizeCell: ExpandSize = .contracted
  
  lazy var imageView: UIImageView = {
    let iv = UIImageView()
    return iv
  }()
  
  lazy var videoView: VideoView = {
    let savedVideo = VideoView()
    savedVideo.player?.play()
    return savedVideo
  }()
  
  lazy var titleForSavedFavoriteVideo: UILabel = {
    let textLabel = UILabel()
    textLabel.text = "Your videos"
    textLabel.textAlignment = .left
    textLabel.font = UIFont(name: "orbitron-light", size: 24)
    textLabel.textColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    textLabel.numberOfLines = 0
    return textLabel
  }()
  
  lazy var descriptionForSavedFavoriteVideo: UITextView = {
    let textView = UITextView()
    textView.text = "Text for description goes here"
    textView.textAlignment = NSTextAlignment.justified
    textView.textColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    textView.font = UIFont(name: "STHeitiSC-Light", size: 12)
    textView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.2039215686, blue: 0.3450980392, alpha: 1)
    textView.isEditable = false
    return textView
  }()
  
  lazy var expandTextViewButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "down"), for: .normal)
    button.addTarget(self, action: #selector(buttonToExpandCellPressed), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
  }
  
  func commonInit() {
    backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    favoriteCellConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @objc private func buttonToExpandCellPressed() {
    
    switch sizeCell {
    case .contracted:
      expandTextViewButton.setImage(UIImage(named: "down"), for: .normal)
      sizeCell = .expanded
      
    case .expanded:
      expandTextViewButton.setImage(UIImage(named: "up"), for: .normal)
      sizeCell = .contracted

    }
  }
  
}

extension FavoriteCollectionCell {
  private func favoriteCellConstraints() {
    videoViewConstraints()
    titleConstraints()
    descriptionContractedConstraints()
    expandButtonConstraints()
  }
  
  private func videoViewConstraints() {
    addSubview(videoView)
    videoView.translatesAutoresizingMaskIntoConstraints = false
    [videoView.centerXAnchor.constraint(equalToSystemSpacingAfter: safeAreaLayoutGuide.centerXAnchor, multiplier: 0.5),
     videoView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1),
     videoView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
     videoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 11)].forEach{$0.isActive = true}
  }
  
  private func titleConstraints() {
    addSubview(titleForSavedFavoriteVideo)
    titleForSavedFavoriteVideo.translatesAutoresizingMaskIntoConstraints = false
    [titleForSavedFavoriteVideo.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 11),
     titleForSavedFavoriteVideo.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11),
     titleForSavedFavoriteVideo.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11)].forEach{$0.isActive = true}
    
  }
  
  private func descriptionContractedConstraints() {
    addSubview(descriptionForSavedFavoriteVideo)
    descriptionForSavedFavoriteVideo.translatesAutoresizingMaskIntoConstraints = false
    [descriptionForSavedFavoriteVideo.topAnchor.constraint(equalTo: titleForSavedFavoriteVideo.bottomAnchor, constant: 11),
     descriptionForSavedFavoriteVideo.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11),
     descriptionForSavedFavoriteVideo.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
     descriptionForSavedFavoriteVideo.heightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1)].forEach{$0.isActive = true}
  }
  
  private func descriptionExpandedConstraints() {
    addSubview(descriptionForSavedFavoriteVideo)
    descriptionForSavedFavoriteVideo.translatesAutoresizingMaskIntoConstraints = false
    [descriptionForSavedFavoriteVideo.topAnchor.constraint(equalTo: titleForSavedFavoriteVideo.bottomAnchor, constant: 11),
     descriptionForSavedFavoriteVideo.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11),
     descriptionForSavedFavoriteVideo.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
     descriptionForSavedFavoriteVideo.heightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.3)].forEach{$0.isActive = true}
  }
  
  private func expandButtonConstraints() {
    addSubview(expandTextViewButton)
    expandTextViewButton.translatesAutoresizingMaskIntoConstraints = false
    expandTextViewButton.topAnchor.constraint(equalTo: titleForSavedFavoriteVideo.bottomAnchor, constant: 11).isActive = true
    expandTextViewButton.leadingAnchor.constraint(equalTo: descriptionForSavedFavoriteVideo.trailingAnchor, constant: 11).isActive = true
    expandTextViewButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11).isActive = true
    expandTextViewButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
  }
}
