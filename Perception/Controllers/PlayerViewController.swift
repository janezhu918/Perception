import UIKit
import AVKit
class PlayerViewController: AVPlayerViewController {
  
    override func viewDidLoad() {
      super.viewDidLoad()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      player?.pause()
    }
  
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
  
    init(player: AVPlayer) {
      super.init(nibName: nil, bundle: nil)
      self.player = player
    }
  
    deinit {
      player?.pause()
    }

}
