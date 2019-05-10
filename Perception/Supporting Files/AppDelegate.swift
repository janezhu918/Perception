import UIKit
import Firebase
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var userSession: UserSession!
    var window: UIWindow?
    var userData = UserDefaults.standard
    var usersession: AuthService!
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            
            self.lockOrientation(orientation)
            
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        
    }


    static var authservice = AuthService()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 2.0)
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        userSession = UserSession()
        usersession = AuthService()
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingVC = storyBoard.instantiateViewController(withIdentifier: "OnBoardingViewController")
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController")
      //  let mainVC = ViewController()
        let navForMainVC = UINavigationController(rootViewController: mainVC)
        let demoCompleted = userData.bool(forKey: Constants.DemoCompletedUserDefaultsKey)
        if demoCompleted {
            self.window?.rootViewController = navForMainVC
        } else {
            self.window?.rootViewController = onboardingVC
        }
        
        self.window?.makeKeyAndVisible()
        
        
        userSession = UserSession()
        //      self.window = UIWindow.init(frame: UIScreen.main.bounds)
        //      self.window?.rootViewController = ViewController()
        //      self.window?.makeKeyAndVisible()
        
        
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
