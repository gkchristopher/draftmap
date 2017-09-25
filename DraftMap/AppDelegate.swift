import UIKit
import QuartzCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customize()
        return true
    }

    private func customize() {
        UINavigationBar.appearance().barTintColor = .drafthouseBlack
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.drafthouseTitle!
        ]
        let image = UIImage(named: "drafthouse-banner.png")!
        UINavigationBar.appearance().setBackgroundImage(image, for: .default)

        UISearchBar.appearance().barTintColor = .drafthouseGold
        UISearchBar.appearance().tintColor = .white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .drafthouseGrey
    }
}

