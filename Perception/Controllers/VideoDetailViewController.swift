import UIKit
import AVFoundation

class VideoDetailViewController: UIViewController {
    private let detailView = VideoDetailView()
    private var video: PerceptionVideo!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
  
    private func configureView(){
        view.addSubview(detailView)
        setupVideo()
    }
  
    private func setupVideo(){
      guard let url = URL(string: video.urlString) else {
        showAlert(title: "Error", message: "Error with Video Playback")
        return
      }
        let player = AVPlayer(url: url)
        detailView.configurePlayer(player: player)
    }
  
    init(video:PerceptionVideo){
        self.video = video
        super.init(nibName: nil, bundle: nil)
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
