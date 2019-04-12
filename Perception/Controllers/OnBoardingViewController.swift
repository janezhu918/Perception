import UIKit
import paper_onboarding

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var contentView: OnboardingView!
    @IBOutlet weak var doneButton: UIButton!
    
    var userData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.dataSource = self
        contentView.delegate = self
        doneButton.addTarget(self, action: #selector(segueToMainVC), for: .touchUpInside)
    }
    
    @objc func segueToMainVC() {
        UserDefaults.standard.set(false, forKey: "Show onboarding") // refarctor
        let viewController = ViewController()
        let navForVC = UINavigationController(rootViewController: viewController)
        self.present(navForVC, animated: true)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        userData.set(true, forKey: "demoCompleted")
        userData.synchronize()
    }
    
    
}

extension OnBoardingViewController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let bgOne = #colorLiteral(red: 0.1163222715, green: 0.1882246733, blue: 0.319499135, alpha: 1)
        let bgTwo = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        let bgThree = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        
        let largeFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        let smallFont = UIFont(name: "HelveticaNeue", size: 16)!
        
       
        
        return [OnboardingItemInfo.init(informationImage: #imageLiteral(resourceName: "camera"), title: "To start allow this app access to your camera", description: """
You can change this by clicking Start, then select Settings > Privacy > Camera. Choose your preferred setting for Allowing access to your camera
"""
, pageIcon: #imageLiteral(resourceName: "circle"), color: bgOne, titleColor: bgTwo, descriptionColor: bgThree, titleFont: largeFont, descriptionFont: smallFont),
                OnboardingItemInfo.init(informationImage: #imageLiteral(resourceName: "HandWithPhoneAR"), title: "Direct the camera over an image", description: "A video will play over the image offering you interactive content about that image", pageIcon: #imageLiteral(resourceName: "circle"), color: bgOne, titleColor: bgTwo, descriptionColor: bgThree, titleFont: largeFont, descriptionFont: smallFont),
                OnboardingItemInfo.init(informationImage: #imageLiteral(resourceName: "VideoAR"), title: "You are now watching a video!", description: "Play, pause, share or save videos to your collection", pageIcon: #imageLiteral(resourceName: "circle"), color: bgOne, titleColor: bgTwo, descriptionColor: bgThree, titleFont: largeFont, descriptionFont: smallFont)][index]
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            doneButton.isHidden = false
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != 2 {
            if doneButton.isHidden == false {
                doneButton.isHidden = true
            }
        }
    }
    
    
    
    
}
