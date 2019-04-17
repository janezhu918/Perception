import UIKit
import SceneKit
import ARKit
import ExpandingMenu


class ViewController: UIViewController {
    
    private let mainView = Main()
    private let usersession: UserSession = (UIApplication.shared.delegate as! AppDelegate).usersession
    private var currentSCNNode: SCNNode?
    private var currentSKVideoNode: SKVideoNode?
    private var videoDictionary: [SCNNode:SKVideoNode] = [:]
    private var userIsLoggedIn = false
    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.sceneView.session.pause()
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
                //TODO: handle save video
            } else {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageSaveVideo, destination: .myVideos)
            }
        }
        let myVideos = ExpandingMenuItem(size: menuButtonSize, title: "My Videos", image: UIImage(named: "table")!, highlightedImage: UIImage(named: "table")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            if self.userIsLoggedIn {
                let destinationVC = SavedVideosViewController()
                self.show(destinationVC, sender: self)
                //                self.present(navBar, animated: true, completion: nil)
            } else {
                self.segueToLoginPage(withMessage: Constants.loginViewMessageViewMyVideos, destination: .myVideos)
            }
        }
        
        
        let profile = ExpandingMenuItem(size: menuButtonSize, title: "Profile", image: UIImage(named: "profile")!, highlightedImage: UIImage(named: "profile")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            if self.usersession.getCurrentUser() != nil {
                let destinationVC = ProfileViewControlerViewController()
                self.show(destinationVC, sender: self)
//                self.navigationController?.pushViewController(destinationVC, animated: true)
//                print("this happened!!")
                
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
            }
        }
    }
}

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let image = CIImage(cvPixelBuffer: frame.capturedImage)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        guard let features = detector?.features(in: image) else { return }
        
        for feature in features as! [CIQRCodeFeature] {
            if let message = feature.messageString {
                let url = URL(string: message)
                let position = SCNVector3(frame.camera.transform.columns.3.x,
                                          frame.camera.transform.columns.3.y,
                                          frame.camera.transform.columns.3.z)
                print(position)
                print(message)
                print(url)
            
        }
    }
}
}

extension ViewController: LoginViewControllerDelegate {
    func checkForLoggedUser(_ logged: Bool) {
        userIsLoggedIn = true
    }
}
