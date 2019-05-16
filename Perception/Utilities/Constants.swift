import UIKit

class Constants {
    static let loginViewMessageSaveVideo = "⚠️ Please sign in to save video ⚠️"
    static let loginViewMessageViewProfile = "⚠️ Please sign in to view profile ⚠️"
    static let loginViewMessageViewMyVideos = "⚠️ Please sign in to view your videos ⚠️"
    static let DemoCompletedUserDefaultsKey = "demoCompleted"
    
    public enum UltimateDestinationEnum {
        case myVideos
        case myProfile
    }
    
    static let savedVideoCollectionViewCellExpandedHeight: CGFloat = 375
    static let savedVideoCollectionViewCellNonExpandedHeight: CGFloat = 300
    static let perceptionGrayColor: UIColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    static let perceptionYellowColor: UIColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
    static let perceptionNavyColor: UIColor = #colorLiteral(red: 0.1276455522, green: 0.2034990788, blue: 0.3436715901, alpha: 1)
    static let userDefaultMessageNoReappear = "messageGoAway"
    static let userDefaultDontShowAgain = "noMoreDoubleTap"
}
