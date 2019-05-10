import UIKit
import Firebase
import AVKit
import ProgressHUD

class SavedVideosViewController: UIViewController {
<<<<<<< HEAD
    
    private var savedVideos = [SavedVideo]() {
        didSet {
            setupExpandingCells()
        }
    }
=======
  
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
     
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
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
          private var savedVideos = [SavedVideo]() {
        didSet {
            setupExpandingCells()
        }
    }
>>>>>>> 556e7b06d0d4997746a251405bdd2b9454350101

    private let savedVideoView = SavedVideos()
    private var savedVideoService: SavedVideoService = DatabaseService()
    private var authservice = AppDelegate.authservice
    private var perceptionUser: PerceptionUser?
    private var cellWidth: CGFloat {
        return savedVideoView.myCollectionView.frame.size.width
    }
    private var isExpanded = [Bool]()
    private var expandedHeight: CGFloat = Constants.savedVideoCollectionViewCellExpandedHeight
    private var nonExpandedHeight: CGFloat = Constants.savedVideoCollectionViewCellNonExpandedHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show("Loading Videos")
        setupUI()
        setupDelegates()
        fetchVideos()
    }
    
<<<<<<< HEAD
=======
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
>>>>>>> 556e7b06d0d4997746a251405bdd2b9454350101
    private func setupDelegates(){
        savedVideoView.myCollectionView.delegate = self
        savedVideoView.myCollectionView.dataSource = self
        savedVideoService.savedVideoServiceDelegate = self
    }
    
    private func setupUI(){
        navigationController?.navigationBar.isHidden = false
        view.addSubview(savedVideoView)
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
    
    private func setupExpandingCells() {
        isExpanded = Array(repeating: false, count: savedVideos.count)
    }
    
}

extension SavedVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let video = savedVideos[indexPath.row]
        guard let cell = savedVideoView.myCollectionView
            .dequeueReusableCell(withReuseIdentifier: "FavoriteCell",
                                 for: indexPath) as? FavoriteCollectionCell,
            let url = URL(string: video.urlString) else { return UICollectionViewCell() }
        let player = AVPlayer(url: url)
        cell.videoTitleLabel.text = video.title
        cell.videoDescriptionLabel.text = video.description
        cell.videoView.player = player
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let savedVideo = savedVideos[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) as? FavoriteCollectionCell,
            let player = cell.videoView.player {
            let playerVC = AVPlayerViewController()
            present(playerVC, animated: true) {
                let currentTime = player.currentTime()
                playerVC.player = player
                playerVC.player?.seek(to: currentTime)
            }
        }
    }
}

extension SavedVideosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cell = collectionView.cellForItem(at: indexPath) as? FavoriteCollectionCell {
            if isExpanded[indexPath.row] {
                //MARK: right here, the label doesn't appear and disappear accordingly.
                cell.videoDescriptionLabel.isHidden = false
                return CGSize(width: cellWidth, height: expandedHeight)
            } else {
                cell.videoDescriptionLabel.isHidden = true
                return CGSize(width: cellWidth, height: nonExpandedHeight)
            }
        }
        return CGSize(width: cellWidth, height: nonExpandedHeight)
    }
}

extension SavedVideosViewController: SavedVideoServiceDelegate {
    func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveError error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func savedVideoService(_ savedVideoService: SavedVideoService, didReceiveVideos videos: [SavedVideo]) {
        self.savedVideos = videos
        savedVideoView.myCollectionView.reloadData()
        ProgressHUD.dismiss()
    }
}

extension SavedVideosViewController: FavoriteCollectionCellDelegate {
    func cellTapped(indexPath: IndexPath) {
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: [.curveEaseInOut], animations: {
            self.savedVideoView.myCollectionView.reloadItems(at: [indexPath])
        })
    }
}
