import UIKit
import paper_onboarding
import MessageUI
import ProgressHUD

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var contentView: OnboardingView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var getResourcesButton: UIButton!
    
    var userData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.dataSource = self
        contentView.delegate = self
        doneButton.addTarget(self, action: #selector(segueToMainVC), for: .touchUpInside)
        getResourcesButton.addTarget(self, action: #selector(presentEmailScreen), for: .touchUpInside)
    }
    
    @objc func presentEmailScreen() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setPreferredSendingEmailAddress(Constants.emailFromAddress)
            mailComposeViewController.setToRecipients(["enterYourEmail@email.com"])
            mailComposeViewController.setSubject(Constants.emailSubject)
            mailComposeViewController.setMessageBody(Constants.emailMessageBody, isHTML: false)

            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            ProgressHUD.showError("Check Internet Connection")
        }
    }
    
    @objc func segueToMainVC() {
        UserDefaults.standard.set(false, forKey: "Show onboarding")
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController")
        let navForMainVC = UINavigationController(rootViewController: mainVC)
        self.present(navForMainVC, animated: true)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        userData.set(true, forKey: Constants.DemoCompletedUserDefaultsKey)
        userData.synchronize()
    }
    
    
}

extension OnBoardingViewController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let largeFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        let smallFont = UIFont(name: "HelveticaNeue", size: 16)!
       
        return [OnboardingItemInfo.init(informationImage: #imageLiteral(resourceName: "camera"), title: "To start allow this app access to your camera", description: """
You can change this by clicking Start, then select Settings > Privacy > Camera. Choose your preferred setting for Allowing access to your camera.
"""
            , pageIcon: #imageLiteral(resourceName: "circle"), color: Constants.perceptionNavyColor, titleColor: Constants.perceptionGrayColor, descriptionColor: Constants.perceptionYellowColor, titleFont: largeFont, descriptionFont: smallFont),
                
                OnboardingItemInfo.init(informationImage: #imageLiteral(resourceName: "HandWithPhoneAR"), title: "Direct the camera over an image", description: """
A video will play over the Perception-enabled image offering you interactive content.

If you don't have Perception-Enabled images, please click on the button underneath.
""", pageIcon: #imageLiteral(resourceName: "circle"), color: Constants.perceptionNavyColor, titleColor: Constants.perceptionGrayColor, descriptionColor: Constants.perceptionYellowColor, titleFont: largeFont, descriptionFont: smallFont),
                
                OnboardingItemInfo.init(informationImage: #imageLiteral(resourceName: "VideoAR"), title: "You are now watching a video!", description: "Play, pause, share or save videos to your collection", pageIcon: #imageLiteral(resourceName: "circle"), color: Constants.perceptionNavyColor, titleColor: Constants.perceptionGrayColor, descriptionColor: Constants.perceptionYellowColor, titleFont: largeFont, descriptionFont: smallFont)][index]
    }
    
//    func onboardingDidTransitonToIndex(_ index: Int) {
//        if index == 1 {
//            getResourcesButton.isHidden = false
//        } else if index == 2 {
//            getResourcesButton.isHidden = true
//            doneButton.isHidden = false
//        }
//    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != 2 {
            doneButton.isHidden = true
        } else {
            doneButton.isHidden = false
        }
        if index != 1 {
            getResourcesButton.isHidden = true
        } else {
            getResourcesButton.isHidden = false
        }
    }
}

extension OnBoardingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
}
