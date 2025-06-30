

import UIKit
import FirebaseCore // Import Firebase Core module
import IQKeyboardManager // Import IQKeyboardManager module
import ChatSDK // Import ChatSDK module

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configure IQKeyboardManager
        IQKeyboardManager.shared()
        
        // Initialize ChatSDK configuration
        let config = BConfiguration.init()
        config.rootPath = "ChatV1" // Set root path
        config.appBadgeEnabled = true // Enable app badge
        config.imageMessagesEnabled = true // Enable image messages
        config.allowUsersToCreatePublicChats = true // Allow users to create public chats
        config.locationMessagesEnabled = false // Disable location messages
        config.showLocalNotifications = true // Show local notifications
        config.onlySendPushToOfflineUsers = false // Send push notifications to both online and offline users
        config.shouldOpenChatWhenPushNotificationClicked = true // Open chat when push notification is clicked
        config.clientPushEnabled = true // Enable client push
        BChatSDK.initialize(config, app: application, options: launchOptions) // Initialize ChatSDK
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: Push Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Register for remote notifications with ChatSDK
        BChatSDK.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Receive remote notification with ChatSDK
        BChatSDK.application(application, didReceiveRemoteNotification: userInfo)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Handle opening URL with ChatSDK
        return BChatSDK.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle opening URL with ChatSDK
        return BChatSDK.application(app, open: url, options: options)
    }
}


