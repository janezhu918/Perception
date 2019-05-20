import UIKit
import AVFoundation
import AVKit
class PlayerViewController: AVPlayerViewController {
    private let shareButton = UIButton(type: .system)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let rotationAnimation = rotateView
        coordinator.animate(alongsideTransition: nil) { (_) in
            rotationAnimation()
        }
    }
    
    init(player: AVPlayer) {
        super.init(nibName: nil, bundle: nil)
        self.player = player
    }
    
    private func configureView() {
        let myView = UIView()
        myView.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.topAnchor.constraint(equalTo: myView.topAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: myView.leadingAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: myView.trailingAnchor).isActive = true
        view.addSubview(myView)
        contentOverlayView?.addSubview(shareButton)
        if UIDevice.current.orientation.isPortrait {
            setPortraitConstraints()
        } else {
            setLandscapeConstraints()
        }
    }
    private func rotateView() {
        if UIDevice.current.orientation.isPortrait {
            UIView.animate(withDuration: 1.0) {
                self.removeConstraints()
                self.setPortraitConstraints()
            }
            
        } else {
            UIView.animate(withDuration: 1.0) {
                self.removeConstraints()
                self.setLandscapeConstraints()
            }
        }
    }
    private func removeConstraints(){
        if let constraints = contentOverlayView?.constraints {
            contentOverlayView?.removeConstraints(constraints)
        }
    }
    
    private func setPortraitConstraints() {
        shareButton.superview?.translatesAutoresizingMaskIntoConstraints = false 
        [NSLayoutConstraint(item: contentOverlayView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0.7, constant: 0),
         NSLayoutConstraint(item: contentOverlayView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.7, constant: 0),
         contentOverlayView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
         contentOverlayView?.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ].forEach { $0?.isActive = true }
    }
    
    private func setLandscapeConstraints() {
        [NSLayoutConstraint(item: contentOverlayView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0.7, constant: 0),
         NSLayoutConstraint(item: contentOverlayView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.7, constant: 0),
         contentOverlayView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
         contentOverlayView?.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ].forEach { $0?.isActive = true }
        
    }
    private func findView(test: (UIView) -> Bool, view: UIView) -> UIView? {
        guard !test(view) else { return view }
        for subview in view.subviews {
            if test(subview) {
                return subview
            } else {
                return findView(test: test, view: subview)
            }
        }
        return nil
    }
    
    deinit {
        player?.pause()
    }
    
}
