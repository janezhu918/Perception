import UIKit
import Firebase

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
        favoriteVideos.myCollectionView.reloadData()
        print(savedVideos.first?.name)
    }
}

