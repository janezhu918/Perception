import UIKit
import ARKit

class Main: ARSCNView {

  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
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
    
  }
}
