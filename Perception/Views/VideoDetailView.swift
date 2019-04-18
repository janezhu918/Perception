import UIKit
import AVFoundation


private struct UI {
  public static let heightMargin: CGFloat = 11
  public static let width: CGFloat = 0.9
  public static let videoHeight: CGFloat = 0.4
}

class VideoDetailView: UIView {

  public lazy var playerView: VideoView = {
    let vv = VideoView()
    vv.playerLayer.cornerRadius = 3.0
    vv.playerLayer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
    return vv
    
  }()
  
  
  public lazy var nameLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "VIDEO NAME"
    lbl.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.3294117647, alpha: 1)
    lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    lbl.layer.cornerRadius = 3.0
//    lbl.layer.borderWidth = 1.0
//    lbl.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    lbl.font = UIFont(name: "STHeitiTC-Medium", size: 32)
    return lbl
  }()
  
  public lazy var descriptionView: UITextView = {
    let tv = UITextView()
    tv.isEditable = false
    tv.text = "This movie is awesome because..."
    tv.font = UIFont(name: "STHeitiTC-Medium", size: 16)
    tv.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.3294117647, alpha: 1)
    tv.textColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
    tv.layer.cornerRadius = 3.0
    tv.layer.borderWidth = 1.0
    tv.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    tv.isEditable = false
    return tv
  }()
 
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    setConstraints()
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func commonInit() {
    backgroundColor = #colorLiteral(red: 0.1347674131, green: 0.2018641531, blue: 0.3395293951, alpha: 1)
    setConstraints()
  }
  
  
  public func configurePlayer(player:AVPlayer){
    playerView.player = player
  }

}

extension VideoDetailView {
  
  private func setConstraints() {
    setPlayerConstraints()
    setNameLabelConstraints()
    setDescriptionConstraints()
  }
  
  private func setPlayerConstraints() {
    addSubview(playerView)
    playerView.translatesAutoresizingMaskIntoConstraints = false
    playerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    playerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11).isActive = true
    playerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11).isActive = true
    playerView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.45).isActive = true
    playerView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
  }
  
  private func setNameLabelConstraints() {
    addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11).isActive = true
    nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11).isActive = true
    nameLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
    nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
  }
  
  private func setDescriptionConstraints() {
    addSubview(descriptionView)
    descriptionView.translatesAutoresizingMaskIntoConstraints = false
    descriptionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 11).isActive = true
    descriptionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11).isActive = true
    descriptionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -11).isActive = true
    descriptionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.35).isActive = true
  }
  
}
