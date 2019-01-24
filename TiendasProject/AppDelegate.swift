

import UIKit
import Firebase
import UserNotifications
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView
import Alamofire
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var isConnectedToNetwork = false
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    var nibContents = Bundle.main.loadNibNamed("activityIndicatorView", owner: nil, options: nil)
    var window: UIWindow?
    var selectedTab:Int = 0
    let locationManager = CLLocationManager()
    var latitude:Double = 0
    var longitude:Double = 0
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red: 138/255.0, green: 138/255.0, blue: 138/255.0, alpha: 1.0)], for: .selected)
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            if String(describing: status) == "notReachable"{
                self.isConnectedToNetwork = false
            }
            else{
                self.isConnectedToNetwork = true
            }
        }
        manager?.startListening()
      
        
          fetchCurrentLocation()
        //MARK:- Google MAP
        GMSServices.provideAPIKey(googleAPI)
        GMSPlacesClient.provideAPIKey(googleAPI)

        //MARK: - FireBase
        /////////////--------------- firebase--------------//////////////////
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        FIRApp.configure()
        
        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]
        
        /////////////////////////////////////////////////////////////////////
        
        
        application.registerForRemoteNotifications()
        
        
        // Override point for customization after application launch.
        return true
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            userDefault.set(refreshedToken, forKey: USER_DEFAULT_FireBaseToken)
        
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    //Fetch Current Location
    // MARK: Fetching User Location
    func fetchCurrentLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        let latestLocation = locations.last!
        print(latestLocation)
        
        //applicationDelegate.longitude = -75.564220
        //applicationDelegate.latitude = 6.217660
        
        applicationDelegate.latitude = latestLocation.coordinate.latitude
        applicationDelegate.longitude = latestLocation.coordinate.longitude
    }
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
       
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        
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
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : FIRMessagingDelegate {
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        
    }

}
extension AppDelegate
{
    func showActivityIndicatorView(){
        let nibMainview = nibContents![0] as! UIView
        nibMainview.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let activityIndicator = (nibMainview.viewWithTag(1)! as! NVActivityIndicatorView)
        activityIndicator.startAnimating()
        self.window?.rootViewController?.view.addSubview(nibMainview)
        nibMainview.center = (self.window?.rootViewController?.view.center)!
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func hideActivityIndicatorView(){
        let nibMainview = nibContents![0] as! UIView
        nibMainview.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
