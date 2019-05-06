import UIKit
import Firebase
import AVKit

class SavedVideosViewController: UIViewController {
  
  private var savedVideos = [SavedVideo]()
  private let favoriteVideos = SavedVideos()
  private var savedVideoService: SavedVideoService = DatabaseService()
  private var authservice = AppDelegate.authservice
  private var perceptionUser: PerceptionUser?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "My Favorite Videos"
    setupUI()
    setupDelegates()
    fetchVideos()
    savedVideoService.savedVideoServiceDelegate = self
  }
  
  private func setupDelegates(){
    favoriteVideos.myCollectionView.delegate = self
    favoriteVideos.myCollectionView.dataSource = self
    savedVideoService.savedVideoServiceDelegate = self
  }
  
  private func setupUI(){
    navigationController?.navigationBar.isHidden = false
    view.addSubview(favoriteVideos)
  }
  
  private func fetchVideos(){
    if let user = authservice.getCurrentUser() {
      DatabaseService.fetchPerceptionUser(uid: user.uid) { [weak self] (perceptionUser, error) in
        if let error = error {
          print("error getting perceptionUser: \(error.localizedDescription)")
        } else if let perceptionUser = perceptionUser {
          self?.perceptionUser = perceptionUser
          self?.savedVideoService.fetchUserSavedVideos(user: perceptionUser)
        }
      }
    }
  }
  
}

extension SavedVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedVideos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let video = savedVideos[indexPath.row]
    guard let cell = favoriteVideos.myCollectionView
      .dequeueReusableCell(withReuseIdentifier: "FavoriteCell",
                           for: indexPath) as? FavoriteCollectionCell,
      let url = URL(string: video.urlString) else { return UICollectionViewCell() }
    let player = AVPlayer(url: url)
    cell.titleForSavedFavoriteVideo.text = video.name
    cell.descriptionForSavedFavoriteVideo.text =
    """
    In the Dark is an American television comedy-drama series, created by Corinne Kingsbury for The CW, which debuted as a mid-season entry during the 2018–19 television season. On January 30, 2018, The CW ordered the show to pilot, with Michael Showalter set to direct. In May 2018, the show received a series order. The series premiered on April 4, 2019. In April 2019, the series was renewed for a second season.
    """
    cell.videoView.player = player
//    cell.layer.borderColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
//    cell.layer.borderWidth = 0.5
//    cell.layer.cornerRadius = 3
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let savedVideo = savedVideos[indexPath.row]
    if let cell = collectionView.cellForItem(at: indexPath) as? FavoriteCollectionCell,
      let player = cell.videoView.player {
      let playerVC = AVPlayerViewController()
      present(playerVC, animated: true) {
        let currentTime = player.currentTime()
        playerVC.player = player
        playerVC.player?.play()
        playerVC.player?.seek(to: currentTime)
      }
    }
  }
}

extension SavedVideosViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width,
                  height: UIScreen.main.bounds.height / 2)

  }
  
  
  
}

extension SavedVideosViewController: SavedVideoServiceDelegate {
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveError error: Error) {
    showAlert(title: "Error", message: error.localizedDescription)
  }
  
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideos videos: [SavedVideo]) {
    self.savedVideos = videos
    favoriteVideos.myCollectionView.reloadData()
  }
}
