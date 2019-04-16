import UIKit
import AVFoundation

class VideoDetailView: UIView {
  private struct UI {
    public static let heightMargin: CGFloat = 11
    public static let width: CGFloat = 0.9
    public static let videoHeight: CGFloat = 0.4
  }
  public lazy var playerView: VideoView = {
    return VideoView()
  }()
  
  public lazy var descriptionView: UITextView = {
    let tv = UITextView()
    tv.isEditable = false
    return tv
  }()
  
  public lazy var nameLabel: UILabel = {
    let lbl = UILabel()
    return lbl
  }()
  
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func commonInit() {
    backgroundColor = #colorLiteral(red: 0.1276455522, green: 0.2034990788, blue: 0.3436715901, alpha: 1)
    setConstraints()
  }
  
  private func setConstraints() {
    addSubview(playerView)
    addSubview(nameLabel)
    addSubview(descriptionView)
    
    playerView.translatesAutoresizingMaskIntoConstraints = false
    descriptionView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    playerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: UI.heightMargin).isActive = true
    playerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: UI.width).isActive = true
    playerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    playerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: UI.videoHeight).isActive = true
    
    nameLabel.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: UI.heightMargin).isActive = true
    nameLabel.widthAnchor.constraint(equalTo: playerView.widthAnchor, constant: UI.width).isActive = true
    nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    descriptionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 11).isActive = true
    descriptionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: UI.width).isActive = true
    descriptionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  public func configurePlayer(player:AVPlayer){
    playerView.player = player
  }

}
