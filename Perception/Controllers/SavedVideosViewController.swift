import UIKit

class SavedVideosViewController: UIViewController {
    private var savedVideos = [SavedVideo]()
    let favoriteVideos = SavedVideos()
    private var savedVideoService: SavedVideoService = DatabaseService()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        fetchVideos()
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
      
    }
    
}

extension SavedVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = favoriteVideos.myCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionCell else { return UICollectionViewCell() }
        let video = savedVideos[indexPath.row]
        cell.textLabel.text = video.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let savedVideo = savedVideos[indexPath.row]
        let savedVideoDetailVC = VideoDetailViewController(video: savedVideo)
        navigationController?.pushViewController(savedVideoDetailVC, animated: true)
    }
}

extension SavedVideosViewController: SavedVideoServiceDelegate {
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveError error: Error) {
    showAlert(title: "Error", message: error.localizedDescription)
  }
  
  func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideos videos: [SavedVideo]) {
    self.savedVideos = videos
  }
}
