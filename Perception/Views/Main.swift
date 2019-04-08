import UIKit
import ARKit

class Main: UIView {
  
  //menu button

  lazy var sceneView: ARSCNView = {
    var scene = ARSCNView()
    return scene
  }()


  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
    setupViews()
    backgroundColor = .white
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func commonInit(){
    setupViews()
  }

}

extension Main {
  func setupViews() {
    setUpSceneView()
    setupButtonView()

  }
  
  func setUpSceneView() {
  addSubview(sceneView)
  sceneView.translatesAutoresizingMaskIntoConstraints = false
  sceneView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
  sceneView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
  sceneView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
  sceneView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
  }
  
  func setupButtonView() {
    
  }
}
