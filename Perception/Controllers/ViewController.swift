import UIKit
import SceneKit
import ARKit
import ExpandingMenu
import AVKit
import Kingfisher
import ProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let messageView = AnimationMessage()
    let defaults = UserDefaults.standard
    var defaultsBool = Bool()
    
    private let databaseService = DatabaseService()
    private var ARImages = Set<ARReferenceImage>() {
        didSet {
            guard oldValue.count == images.count - 1 else { return }
            let configuration = ARImageTrackingConfiguration()
            configuration.trackingImages = ARImages
            configuration.maximumNumberOfTrackedImages = 1
        }
    }
    private let usersession: UserSession = (UIApplication.shared.delegate as! AppDelegate).userSession
    private var currentSCNNode: SCNNode?
    private var currentSKVideoNode: SKVideoNode?
    private var videoPlayer: AVPlayer?
    private var videoDictionary: [SCNNode:SKVideoNode] = [:]
    private var userIsLoggedIn = false
    private var authservice = AppDelegate.authservice
    private var images = [PerceptionImage]()
    private var savedVideos = [SavedVideo]()
    private var videos = [PerceptionVideo]()
    private var isAnImageDetected = Bool()
    private var videoObservationToken: NSKeyValueObservation?
    private var currentTime: CMTime?
    private var observer: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messageView)
        addExpandingMenu()
        orientationSetup()
        fetchImages()
        fetchVideos()
        self.view.backgroundColor = .clear
        authservice.authserviceSignOutDelegate = self
        self.navigationController?.navigationBar.isHidden = true
        setupDoubleTapGesture()
        setupSaveGesture()
        self.sceneView.delegate = self
        self.sceneView.showsStatistics = false
        setupAlertMessages()
        checkForLoggedUser()
        doubleTapPreference()
        hideDoubleTapMessage()
        checkForPreference()
    }
    
    private func setupAlertMessages() {
        messageView.buttonScape.addTarget(self, action:#selector(setView), for: .touchUpInside)
        messageView.okButton.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        messageView.okOndoubleTap.addTarget(self, action: #selector(okDoubleTapPressed), for: .touchUpInside)
        messageView.doubleTapNotShow.addTarget(self, action: #selector(dtViewGoAway), for: .touchUpInside)
    }
    
    @objc func okPressed() {
        messageView.alertView.fadeOut()
        messageView.messageLabel.fadeOut()
        messageView.titleLabel.fadeOut()
        messageView.okButton.fadeOut()
        messageView.menuImage.fadeOut()
        messageView.buttonScape.fadeOut()
        messageView.closeButton.fadeOut()
    }
    
    @objc func okDoubleTapPressed() {
        hideOneView()
    }
    
    @objc func setView() {
        defaultsBool = true
        if defaultsBool {
            messageView.fadeOut()
            defaults.set(defaultsBool, forKey: Constants.userDefaultMessageNoReappear)
        }
    }
    
    @objc func dtViewGoAway() {
        defaultsBool = true
        if defaultsBool {
            messageView.fadeOut()
            defaults.set(defaultsBool, forKey: Constants.userDefaultDontShowAgain)
        }
    }
    
    func showOneView() {
        messageView.doubleTapView.isHidden = false
        messageView.doubleTapMessage.isHidden = false
        messageView.okOndoubleTap.isHidden = false
        messageView.doubleTapNotShow.isHidden = false
        messageView.iconDoubleTap.isHidden = false
        
        messageView.doubleTapView.fadeIn()
        messageView.doubleTapMessage.fadeIn()
        messageView.okOndoubleTap.fadeIn()
        messageView.doubleTapNotShow.fadeIn()
        messageView.iconDoubleTap.fadeIn()
    }
    
    func hideOneView() {
        messageView.doubleTapView.fadeOut()
        messageView.doubleTapMessage.fadeOut()
        messageView.okOndoubleTap.fadeOut()
        messageView.doubleTapNotShow.fadeOut()
        messageView.iconDoubleTap.fadeOut()
    }
    
    func hideDoubleTapMessage() {
        messageView.doubleTapView.isHidden = true
        messageView.doubleTapMessage.isHidden = true
        messageView.okOndoubleTap.isHidden = true
        messageView.doubleTapNotShow.isHidden = true
        messageView.iconDoubleTap.isHidden = true
    }
    
    func checkForPreference() {
        let preference = defaults.bool(forKey: Constants.userDefaultMessageNoReappear)
        
        if preference {
            defaultsBool = true
            messageView.alertView.isHidden = true
            messageView.messageLabel.isHidden = true
            messageView.titleLabel.isHidden = true
            messageView.okButton.isHidden = true
            messageView.buttonScape.isHidden = true
            messageView.closeButton.isHidden = true
            messageView.menuImage.isHidden = true
        }
    }
    
    func doubleTapPreference() {
        let doubleTapPref = defaults.bool(forKey: Constants.userDefaultDontShowAgain)
        
        if doubleTapPref {
            defaultsBool = true
            hideDoubleTapMessage()
        }
    }
    
    private var isPlaying = false {
        didSet {
            switchPlayback(isPlaying)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    private func setupDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
    }
    
    private func setupSaveGesture() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(saveVideo))
        swipeUpGesture.direction = .right
        view.addGestureRecognizer(swipeUpGesture)
    }
    
    private func checkForLoggedUser() {
        if usersession.getCurrentUser() != nil {
            userIsLoggedIn = true
        } else {
            userIsLoggedIn = false
        }
    }
    
    @objc private func doubleTap() {
        let playerVC = AVPlayerViewController()
        guard let confirmedVideoTimeState = currentTime else { fatalError("confirmedVideoTimeState at objc doubleTap method is nil") }
        if let currentVideoPlayer = videoPlayer {
            playerVC.player = currentVideoPlayer
            present(playerVC, animated: true) {
                playerVC.player?.seek(to: confirmedVideoTimeState)
                playerVC.player?.play()
            }
        } else {
            print("no video to expand")
        }
    }
    
    private func switchPlayback(_ isPlaying: Bool) {
        if isPlaying {
            currentSKVideoNode?.pause()
        } else {
            currentSKVideoNode?.play()
        }
    }
    
    
    private func fetchImages() {
        let imageService: ImageService = databaseService
        imageService.fetchImages(contextID: "local") { [weak self] (result) in
            switch result {
            case .success(let images):
                self?.images = images
            case .failure(error: let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func fetchVideos() {
        let videoService: VideoService = databaseService
        videoService.fetchVideos { (result) in
            switch result {
            case .success(let videos):
                self.videos = videos
            case .failure(error: let error):
                self.showAlert(title: "Error", message:error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImage = ARReferenceImage.referenceImages(inGroupNamed: "ARPerception", bundle: Bundle.main){
            
            configuration.trackingImages = trackedImage
            configuration.maximumNumberOfTrackedImages = 1
        }
        checkForLoggedUser()
        sceneView.session.run(configuration)
        AppUtility.lockOrientation(.portrait)
        
    }
    
    private func setupARImages(){
        guard images.count > 0 else { return }
        
        images.forEach { [weak self] image in
            createARReferenceImage(image: image, completion: { (result) in
                switch result {
                case .success(let uiImage):
                    if let orientation = self?.toCGImageOrientation(orientation: image.orientation), let cgImage = uiImage.cgImage {
                        let arImage = ARReferenceImage(cgImage, orientation:orientation, physicalWidth: CGFloat(image.width))
                        arImage.name = image.name
                        self?.ARImages.insert(arImage)
                    }
                case .failure(error:): return
                }
            })
        }
    }
    
    private func toCGImageOrientation(orientation:Orientation) -> CGImagePropertyOrientation {
        switch orientation {
        case .up: return .up
        case .upMirrored: return .upMirrored
        case .down: return .down
        case .downMirrored: return .downMirrored
        case .left: return .left
        case .leftMirrored: return .leftMirrored
        case .right: return .right
        case .rightMirrored: return .rightMirrored
        }
    }
    
    private func createARReferenceImage(image:PerceptionImage, completion:@escaping(Result<UIImage>) -> Void) {
        guard let url = URL(string: image.urlString) else { return }
        let cache = ImageCache.default
        cache.retrieveImage(forKey: image.urlString, completionHandler: { [weak self] (result) in
            switch result {
            case .success(let value):
                if let uiImage = value.image {
                    completion(.success(uiImage))
                } else {
                    self?.handleDownImage(url: url, completion: { (result) in
                        switch result {
                        case .success(let uiImage):
                            completion(.success(uiImage))
                        case .failure(error: let error):
                            completion(.failure(error: error))
                        }
                    })
                }
            case .failure(let error):
                completion(.failure(error: error))
                self?.downloadImage(url: url, completion: { (result) in
                    switch result {
                    case .success(let uiImage):
                        completion(.success(uiImage))
                    case .failure(error: let error):
                        completion(.failure(error: error))
                    }
                })
            }
        })
    }
    
    
    private func downloadImage(url:URL,
                               completion:@escaping(Result<UIImage>) -> Void) {
        let downloader = KingfisherManager.shared
        let cache = ImageCache.default
        downloader.retrieveImage(with: url) { (result) in
            switch result {
            case .success(let value):
                cache.store(value.image, forKey: url.absoluteString)
                completion(.success(value.image))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    private func handleDownImage(url:URL,
                                 completion:@escaping(Result<UIImage>) -> Void) {
        downloadImage(url: url) { result in
            switch result {
            case .success(let uiImage):
                completion(.success(uiImage))
            case .failure(error: let error):
                completion(.failure(error: error))
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        currentSKVideoNode?.pause()
        AppUtility.lockOrientation(.all)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first?.location(in: sceneView) else {fatalError("Could not find images in asset folder")}
        isPlaying = !isPlaying
    }
    
    private func segueToLoginPage(withMessage message: String, destination: Constants.UltimateDestinationEnum) {
        let destinationVC = LoginViewController()
        destinationVC.ultimateDestination = .myVideos
        destinationVC.displayMessage = message
        destinationVC.showMessage = true
        destinationVC.modalPresentationStyle = .overCurrentContext
        present(destinationVC, animated: true, completion: nil)
    }
    
    @objc private func saveVideo() {
        let savedVideoService: SavedVideoService = databaseService
        if let authUserId = usersession.getCurrentUser()?.uid {
            DatabaseService.fetchPerceptionUser(uid: authUserId, completion: { (user, error) in
                if let user = user, let name = self.currentSKVideoNode?.name,
                    let video = (self.videos.first { $0.name == name }) {
                    let id = savedVideoService.generateSavedVideoId(user: user)
                    let date = Date.getISOTimestamp()
                    let savedVideo = SavedVideo(id: id, name: video.name, description: video.description, urlString: video.urlString, title: video.title, savedAt: date)
                    savedVideoService.storeVideo(video: savedVideo, user: user) { result in
                        switch result {
                        case .success(_):
                            ProgressHUD.showSuccess("Video Saved Successfully")
                        case .failure(error:):
                            ProgressHUD.showError("Unable to Save Duplicate Video")
                        }
                    }
                } else {
                    print("no image detected")
                    self.showAlert(title: "No Image Detected", message: "Point the camera towards an image")
                }
            })
        }
    }
    
    private func orientationSetup() {
        if UIDevice.current.orientation.isPortrait {
            addExpandingMenu()
        } else if UIDevice.current.orientation.isLandscape {
            addExpandingMenu()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { (_) in
            self.orientationSetup()
        }
    }
    
    @objc private func shareVideo() {
        if let videoToShare =  self.currentSKVideoNode?.name,
            let videoURL = (self.images.first { $0.name == videoToShare })?.videoURLString {
            let activityViewController = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
            self.present(activityViewController, animated: true)
        } else {
            self.showAlert(title: "No Image Detected", message: "Point the camera towards an image to share it.")
        }
    }
    
    private func addExpandingMenu() {
        let menuButtonSize: CGSize = CGSize(width: 35, height: 35)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "moreBlue")!, rotatedImage: UIImage(named: "moreBlue")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 34.0, y: self.view.bounds.height - 78.0)
        menuButton.layer.cornerRadius = 5
        menuButton.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        let share = ExpandingMenuItem(size: menuButtonSize, title: "Share", image: UIImage(named: "shareBlue")!, highlightedImage: UIImage(named: "shareBlue")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.shareVideo()
        }
        
        let save = ExpandingMenuItem(size: menuButtonSize, title: "Save", image: UIImage(named: "starBlue")!, highlightedImage: UIImage(named: "starBlue")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            print("video saved")
            if self.userIsLoggedIn {
                self.saveVideo()
            } else {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageSaveVideo, destination: .myVideos)
            }
        }
        
        let myVideos = ExpandingMenuItem(size: menuButtonSize, title: "My Videos", image: UIImage(named: "tableBlue")!, highlightedImage: UIImage(named: "tableBlue")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.checkForLoggedUser()
            if self.userIsLoggedIn {
                let savedVideosVC = SavedVideosViewController()
                self.navigationController?.pushViewController(savedVideosVC, animated: true)
            } else {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageViewMyVideos, destination: .myVideos)
            }
        }
        
        let profile = ExpandingMenuItem(size: menuButtonSize, title: "Profile", image: UIImage(named: "userBlue")!, highlightedImage: UIImage(named: "userBlue")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            if self.usersession.getCurrentUser() != nil {
                let profileVC = ProfileViewControlerViewController()
                self.navigationController?.pushViewController(profileVC, animated: true)
            } else if self.userIsLoggedIn == false {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageViewProfile, destination: .myProfile)
                print("nothing happened")
            }
        }
        
        let signOut = ExpandingMenuItem(size: menuButtonSize, title: "Sign Out", image: UIImage(named: "userBlue")!, highlightedImage: UIImage(named: "userBlue")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            if self.userIsLoggedIn {
                self.authservice.signOutAccount()
            } else {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageViewProfile, destination: .myProfile)
            }
        }
        
        let menuItems = [signOut, share, save, myVideos, profile]
        menuItems.forEach{ $0.layer.cornerRadius = 5 }
        menuItems.forEach{ $0.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) }
        menuItems.forEach{ $0.titleColor = .init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1) }
        menuItems.forEach{ $0.titleMargin = 10 }
        menuButton.playSound = false
        menuButton.addMenuItems(menuItems)
        menuButton.willDismissMenuItems = { (menu) -> Void in
            menuItems.forEach{ $0.isHidden = true }
        }
        menuButton.willPresentMenuItems = { (menu) -> Void in
            menuItems.forEach{ $0.isHidden = false }
        }
        view.addSubview(menuButton)
    }
    
} 

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let referenceImage = imageAnchor.referenceImage.name!.description
            
            guard let videoUrlForVideoPlayer = Bundle.main.url(forResource: referenceImage, withExtension: ".mp4") else  { return node }
            let player = AVPlayer(url: videoUrlForVideoPlayer)
            let videoNode = SKVideoNode(avPlayer: player)
            currentSKVideoNode = SKVideoNode(url: videoUrlForVideoPlayer)
            
            guard currentSKVideoNode != nil else { fatalError("error unwrapping currentSKVideoNode in first renderer") }
            
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            videoNode.yScale = -1.0
            videoNode.name = imageAnchor.referenceImage.name!.description
            videoScene.addChild(videoNode)
            
            observer = player.addPeriodicTimeObserver(forInterval: CMTime.init(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (time) in
                self.currentTime = time
                print("This is the observer at first renderer printing time\(time)")
            })
            
            videoPlayer = player
            videoNode.play()
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = videoScene
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
        } else {
            print("No image was detected at renderer function")
        }
        
        currentSCNNode = node
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let currentSCNNode = currentSCNNode, let currentSKVideoNode = currentSKVideoNode {
            videoDictionary[currentSCNNode] = currentSKVideoNode
            DispatchQueue.main.async {
                self.showOneView()
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print ("This is the observer at didUpdate renderer \(String(describing: currentTime)) - \(String(describing: observer))")
        if let currentVideoPlaying = videoPlayer, let trackable = anchor as? ARImageAnchor {
            if !trackable.isTracked {
                currentVideoPlaying.pause()
                currentSKVideoNode = nil
                DispatchQueue.main.async {
                    self.hideOneView()
                }
            }
        }
    }
}

extension ViewController: LoginViewControllerDelegate {
    func checkForLoggedUser(_ logged: Bool) {
        userIsLoggedIn = true
    }
}

extension ViewController: AuthServiceSignOutDelegate {
    func didSignOutWithError(_ authservice: AuthService, error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func didSignOut(_ authservice: AuthService) {
        showAlert(title: "Signed Out", message: "Signed Out Successfully.")
        ProgressHUD.dismiss()
        func checkForLoggedUser(_ logged: Bool) {
            userIsLoggedIn = true
        }
    }
}
