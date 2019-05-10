import UIKit
import SceneKit
import ARKit
import ExpandingMenu
import AVKit
import Kingfisher
import ProgressHUD

class CustomSKVideoNode: SKVideoNode {
    public var videoPlayer: AVPlayer?
    override init(url: URL) {
        super.init(url: url)
        videoPlayer = AVPlayer(url: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let messageView = AnimationMessage()
    let defaults = UserDefaults.standard
    var defaultsBool = Bool()
    
    struct Keys {
        static let noMoreMessage = "messageGoAway"
    }
    
    private let databaseService = DatabaseService()
    // private let mainView = Main()
    private var ARImages = Set<ARReferenceImage>() {
        didSet {
            guard oldValue.count == images.count - 1 else { return }
            let configuration = ARImageTrackingConfiguration()
            configuration.trackingImages = ARImages
            configuration.maximumNumberOfTrackedImages = 1
            // mainView.sceneView.session.run(configuration)
        }
    }
    private let usersession: UserSession = (UIApplication.shared.delegate as! AppDelegate).userSession
    private var currentSCNNode: SCNNode?
    private var currentSKVideoNode: CustomSKVideoNode?
    private var videoDictionary: [SCNNode:CustomSKVideoNode] = [:]
    private var userIsLoggedIn = false
    private var authservice = AppDelegate.authservice
    private var images = [PerceptionImage]()
    private var savedVideos = [SavedVideo]()
    private var videos = [PerceptionVideo]()
    private var menuButton: ExpandingMenuButton!
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
        // addExpandingMenu()
        self.sceneView.delegate = self
        self.sceneView.showsStatistics = false
        checkForLoggedUser()
        messageView.buttonScape.addTarget(self, action:#selector(setView), for: .touchUpInside)
        checkForPreference()
    }
    
    
    @objc func setView() {
        defaultsBool = true
        if defaultsBool {
            messageView.fadeOut()
            defaults.set(defaultsBool, forKey: Keys.noMoreMessage)
        }
    }
    
    func checkForPreference() {
        let preference = defaults.bool(forKey: Keys.noMoreMessage)
        
        if preference {
            defaultsBool = true
            messageView.isHidden = true
            
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
        //TODO: add up view that displays only the video
        let playerVC = AVPlayerViewController()
        if let currentSKVideoNode = currentSKVideoNode {
            if let currentVideoPlayer = currentSKVideoNode.videoPlayer {
                playerVC.player = currentVideoPlayer
                // let currentTime = currentVideoPlayer.currentTime()
                let currentItem = currentVideoPlayer.currentItem?.currentTime()
                present(playerVC, animated: true) {
                    //  playerVC.player?.playImmediately(atRate: 1.0)
                    playerVC.player?.seek(to: currentItem!)
                }
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
                self?.setupARImages()
            case .failure(error: let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func fetchVideos(){
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
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
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
        // mainView.sceneView.session.pause()
        sceneView.session.pause()
        currentSKVideoNode?.pause()
        
        // Don't forget to reset when view is being removed
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
                            self.showAlert(title: "Success", message: "Video Saved Successfully")
                        case .failure(error:):
                            self.showAlert(title: "Error", message: "Unable to Save Duplicate Video")
                        }
                    }
                } else {
                    print("no image detected")
                    self.showAlert(title: "No image detected", message: "Point the camera towards an image")
                }
            })
        }
    }
    
    private func orientationSetup() {
        
        //TODO: not add the view everytime it rotates
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
    //change the frame
    
    @objc private func shareVideo() {
        if let videoToShare =  self.currentSKVideoNode?.name,
            let videoURL = (self.images.first { $0.name == videoToShare })?.videoURLString {
            let activityViewController = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
            self.present(activityViewController, animated: true)
            print("trying to share video")
        } else {
            self.showAlert(title: "No image detected to share", message: "Point to an image to share it")
        }
    }
    
    //
    private func addExpandingMenu() {
        let menuButtonSize: CGSize = CGSize(width: 35, height: 35)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "moreBlue")!, rotatedImage: UIImage(named: "moreBlue")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 34.0, y: self.view.bounds.height - 34.0)
        
        //        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "more")!, rotatedImage: UIImage(named: "more")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 32.0)
        view.addSubview(menuButton)
        menuButton.layer.cornerRadius = 5
        //        menuButton.bottomViewColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        //        menuButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 0.5)
        menuButton.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        let share = ExpandingMenuItem(size: menuButtonSize, title: "Share", image: UIImage(named: "shareBlue")!, highlightedImage: UIImage(named: "shareBlue")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            //        menuButton.addButton(title: <#T##String#>, image: <#T##UIImage#>, highlightedImage: <#T##UIImage#>, backgroundImage: <#T##UIImage?#>, backgroundHighlightedImage: <#T##UIImage#>, action: <#T##(() -> ())?##(() -> ())?##() -> ()#>)
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
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let referenceImage = imageAnchor.referenceImage.name!.description
            let videoUrlForVideoPlayer = Bundle.main.url(forResource: referenceImage, withExtension: ".mp4")
            let videoNode = CustomSKVideoNode(url: videoUrlForVideoPlayer!)
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            videoNode.yScale = -1.0
            videoScene.addChild(videoNode)
            videoNode.name = imageAnchor.referenceImage.name!.description
            currentSKVideoNode = videoNode
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
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let currentVideoPlaying = videoDictionary[node], let trackable = anchor as? ARImageAnchor {
            currentSKVideoNode = currentVideoPlaying
            if !trackable.isTracked {
                currentVideoPlaying.pause()
                currentSKVideoNode = nil
            } else {
                currentSKVideoNode = currentVideoPlaying
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
