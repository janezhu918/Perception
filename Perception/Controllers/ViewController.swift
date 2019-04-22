import UIKit
import SceneKit
import ARKit
import ExpandingMenu
import Kingfisher

class ViewController: UIViewController {
    private let databaseService = DatabaseService()
    private let mainView = Main()
    private var ARImages = Set<ARReferenceImage>() {
      didSet {
        guard oldValue.count == images.count - 1 else { return }
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = ARImages
        configuration.maximumNumberOfTrackedImages = 1
        mainView.sceneView.session.run(configuration)
      }
    }
    private let usersession: UserSession = (UIApplication.shared.delegate as! AppDelegate).userSession
    private var currentSCNNode: SCNNode?
    private var currentSKVideoNode: SKVideoNode?
    private var videoDictionary: [SCNNode:SKVideoNode] = [:]
    private var userIsLoggedIn = false
    private var authservice = AppDelegate.authservice
    private var images = [PerceptionImage]()
    private var savedVideos = [SavedVideo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(mainView)
        addExpandingMenu()
        mainView.sceneView.delegate = self
        mainView.sceneView.session.delegate = self
        mainView.sceneView.showsStatistics = false
        checkForLoggedUser()
    }
    
    private var isPlaying = false {
        didSet {
            switchPlayback(isPlaying)
        }
    }
    
    private func checkForLoggedUser() {
        if usersession.getCurrentUser() != nil {
            userIsLoggedIn = true
        } else {
            userIsLoggedIn = false
        }
        print("check if user is logged in: \(userIsLoggedIn)")
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
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let configuration = ARImageTrackingConfiguration()
      
        if let trackedImage = ARReferenceImage.referenceImages(inGroupNamed: "ARPerception", bundle: Bundle.main){
            configuration.trackingImages = trackedImage
            configuration.maximumNumberOfTrackedImages = 1
        }
        checkForLoggedUser()
        mainView.sceneView.session.run(configuration)
      
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
              case .failure(error: let error): return
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
        mainView.sceneView.session.pause()
        currentSKVideoNode?.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first?.location(in: mainView.sceneView) else {fatalError("Could not find images in asset folder")}
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
    
  private func saveVideo() {
    let savedVideoService: SavedVideoService = databaseService
    if let authUserId = self.usersession.getCurrentUser()?.uid {
      DatabaseService.fetchPerceptionUser(uid: authUserId, completion: { (user, error) in
        if let user = user, let name = self.currentSKVideoNode?.name,
          let videoURL = (self.images.first { $0.name == name })?.videoURLString {
          let id = savedVideoService.generateSavedVideoId(user: user)
          let date = Date.getISOTimestamp()
          let savedVideo = SavedVideo(id: id, name: name, description: "", urlString: videoURL, savedAt: date)
          savedVideoService.storeVideo(video: savedVideo, user: user) { result in
            switch result {
            case .success(_):
              self.showAlert(title: "Success", message: "Video Saved Successfully")
            case .failure(error: let error):
              print(error)
            }
          }
        }
      })
    }
  }
  
  private func addExpandingMenu() {
        let menuButtonSize: CGSize = CGSize(width: 30, height: 30)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "more")!, rotatedImage: UIImage(named: "more")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 32.0)
        view.addSubview(menuButton)
        menuButton.layer.cornerRadius = 5
        //        menuButton.bottomViewColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        //        menuButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 0.5)
        menuButton.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        let share = ExpandingMenuItem(size: menuButtonSize, title: "Share", image: UIImage(named: "share")!, highlightedImage: UIImage(named: "share")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            print("trying to share video")
            //                if let videoToShare = video {
            //                            let activityViewController = UIActivityViewController(activityItems: [videoToShare], applicationActivities: nil)
            //                            present(activityViewController, animated: true)
            //                        }
        }
        let save = ExpandingMenuItem(size: menuButtonSize, title: "Save", image: UIImage(named: "starEmpty")!, highlightedImage: UIImage(named: "starEmpty")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            print("video saved")
            if self.userIsLoggedIn {
              self.saveVideo()
            } else {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageSaveVideo, destination: .myVideos)
            }
        }
        let myVideos = ExpandingMenuItem(size: menuButtonSize, title: "My Videos", image: UIImage(named: "table")!, highlightedImage: UIImage(named: "table")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.checkForLoggedUser()
            if self.userIsLoggedIn {
                let destinationVC = SavedVideosViewController()
                self.show(destinationVC, sender: self)
           
            } else {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageViewMyVideos, destination: .myVideos)
            }
        }
        
        
        let profile = ExpandingMenuItem(size: menuButtonSize, title: "Profile", image: UIImage(named: "profile")!, highlightedImage: UIImage(named: "profile")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            if self.usersession.getCurrentUser() != nil {
                let profileVC = ProfileViewControlerViewController()
                    //self.navigationController?.pushViewController(destinationVC, animated: true)
                 self.show(profileVC, sender: self)
                        print("this happened!!")
                
            } else if self.userIsLoggedIn == false {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageViewProfile, destination: .myProfile)
                print("nothing happened")
            }
        }
        
        let signOut = ExpandingMenuItem(size: menuButtonSize, title: "Sign Out", image: UIImage(named: "profile")!, highlightedImage: UIImage(named: "profile")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            if self.userIsLoggedIn {
                self.authservice.signOutAccount()
            } else {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageViewProfile, destination: .myProfile)
            }
        }
        let menuItems = [signOut, share, save, myVideos, profile]
        menuItems.forEach{ $0.layer.cornerRadius = 5 }
        menuItems.forEach{ $0.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 0.5) }
        menuItems.forEach{ $0.titleColor = .init(red: 1, green: 1, blue: 1, alpha: 1) }
        menuItems.forEach{ $0.titleMargin = 5 }
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
            let videoNode = SKVideoNode(fileNamed: "\(imageAnchor.referenceImage.name!.description).mp4")
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

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        let image = CIImage(cvPixelBuffer: frame.capturedImage)
//        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
//        guard let features = detector?.features(in: image) else { return }
        
//        for feature in features as! [CIQRCodeFeature] {
//            if let message = feature.messageString {
//                let url = URL(string: message)
//                let position = SCNVector3(frame.camera.transform.columns.3.x,
//                                          frame.camera.transform.columns.3.y,
//                                          frame.camera.transform.columns.3.z)
//                print(position)
//                print(message)
//                print(url)
//
//            }
//        }
    }
}

extension ViewController: LoginViewControllerDelegate {
    func checkForLoggedUser(_ logged: Bool) {
        userIsLoggedIn = true
    }
}
