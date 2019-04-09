import UIKit
import SceneKit
import ARKit
import ExpandingMenu

class ViewController: UIViewController {
  
  let mainView = Main()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(mainView)
    addExpandingMenu()
    mainView.sceneView.delegate = self
    mainView.sceneView.showsStatistics = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARImageTrackingConfiguration()
    
    if let trackedImage = ARReferenceImage.referenceImages(inGroupNamed: "ARPerception", bundle: Bundle.main){
      configuration.trackingImages = trackedImage
      configuration.maximumNumberOfTrackedImages = 1
      print("images found in viewWillAppear trackedImage")
    }
    
    mainView.sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mainView.sceneView.session.pause()
  }
    
    private func addExpandingMenu() {
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "job")!, rotatedImage: UIImage(named: "job")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 72.0)
        view.addSubview(menuButton)
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Filter", image: UIImage(named: "filter")!, highlightedImage: UIImage(named: "filter")!, backgroundImage: UIImage(named: "filter"), backgroundHighlightedImage: UIImage(named: "filter")) { () -> Void in
            print("item1 clicked")
        }
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "Filter", image: UIImage(named: "filter")!, highlightedImage: UIImage(named: "filter")!, backgroundImage: UIImage(named: "filter"), backgroundHighlightedImage: UIImage(named: "filter")) { () -> Void in
            print("item1 clicked")
        }
        menuButton.addMenuItems([item1/*, item2, item3, item5*/])
        view.addSubview(menuButton)
    }

}

extension ViewController: ARSCNViewDelegate {
  
  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    let node = SCNNode()
    if let imageAnchor = anchor as? ARImageAnchor {
      
      let videoNode = SKVideoNode(fileNamed: "\(imageAnchor.referenceImage.name!.description).mp4")
      videoNode.play()
      let videoScene = SKScene(size: CGSize(width: 480, height: 360))
      videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
      videoNode.yScale = -1.0
      videoScene.addChild(videoNode)
      
      let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
      plane.firstMaterial?.diffuse.contents = videoScene
      let planeNode = SCNNode(geometry: plane)
      planeNode.eulerAngles.x = -.pi/2
      node.addChildNode(planeNode)
      
    } else {
      print("No image was detected at renderer function")
    }
    return node
  }
}
