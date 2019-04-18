import UIKit
import Firebase
import AVFoundation

class SavedVideosViewController: UIViewController {
    
    private var savedVideos = [SavedVideo]()
    private let favoriteVideos = SavedVideos()
    private var savedVideoService: SavedVideoService = DatabaseService()
    private var authservice = AppDelegate.authservice
    private var perceptionUser: PerceptionUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.textLabel.text = video.name
        cell.videoView.player = player
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let savedVideo = savedVideos[indexPath.row]
        let savedVideoDetailVC = VideoDetailViewController(video: savedVideo)
        navigationController?.pushViewController(savedVideoDetailVC, animated: true)
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

