//
//  AppDelegate.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import SideMenu
import StripeCore
import Stripe
import FirebaseAnalytics
import FirebaseMessaging

let googleApiKey = "AIzaSyASJNkT8UuVEyVFIaayYMDHnh0rO-thTMk"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy private var router = RootRouter()
    lazy private var deeplinkHandler = DeeplinkHandler()
    lazy private var notificationsHandler = NotificationsHandler()
    lazy private var checkTime = CheckTimeViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        Thread.sleep(forTimeInterval: 2.0)
        notificationsHandler.configure()
        Router.default.setupAppNavigation(appNavigation: AppNavigation())
        checkTime.CheckTimeFunc()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses.append(ChooseYourCityViewController.self)
//        setRoot2()
        GMSServices.provideAPIKey(googleApiKey)
        STPAPIClient.shared.publishableKey = "pk_test_51JjwCIFfJpDd1neCmXZhVhPcf1134OL4GgSP3i8Kixg15WQ32cwXQJsQzj1rOxfq2sfNF1R7lfiHaRK49iFuZKAv00PzrVPDfX"
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = "204112636650-p3f1o8op0ed79dsurlvicnljt7itqkdc.apps.googleusercontent.com"
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        window = UIWindow(frame: UIScreen.main.bounds)
        setRootController()
        registerLocal(application: application)
        Messaging.messaging().delegate = self
        application.applicationIconBadgeNumber = 0
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = AppColor.primaryBackgroundColor
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
              // UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                UITabBar.appearance().standardAppearance = tabBarAppearance
            }
        }
        return true
    }


    func registerLocal(application:UIApplication) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Permission Granted!")
                    Messaging.messaging().token { token, error in
                      if let error = error {
                        print("Error fetching FCM registration token: \(error)")
                      } else if let token = token {
                        print("FCM registration token: \(token)")
                        UserStoreSingleton.shared.fcmToken = token
                      }
                    }
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }

                } else {
                    print("Permission Dennied")
                }
            }
        }


    func setRootController(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        } else {}
        if let window = self.window{
                    let isLogin = UserStoreSingleton.shared.isLoggedIn
                    let authToken = UserStoreSingleton.shared.Token
            if(isLogin ?? false){
//                        let viewController = BaseNavigationController(rootViewController: Storyboard.Splash.viewController(for: HomeViewController.self))
                        //   SideMenu.shared.setupSideMneu()
                        RootRouter().loadMainHomeStructure()
//                        viewController.view.layoutIfNeeded()
//                        window.rootViewController = viewController
                    }else{
                        let viewController = BaseNavigationController(rootViewController: Storyboard.Authentication.viewController(for: LoginViewController.self))
                        //   SideMenu.shared.setupSideMneu()
                        viewController.view.layoutIfNeeded()
                        window.rootViewController = viewController
                        print("Token","Null")

                    }

            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            }, completion: nil)
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }


    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // To enable full universal link functionality add and configure the associated domain capability
        // https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            deeplinkHandler.handleDeeplink(with: url)
        }
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var flag: Bool = false
       if  ApplicationDelegate.shared.application(
                    app,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
       ) {
      flag = ApplicationDelegate.shared.application(
                     app,
                     open: url,
                     sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                     annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

        
       }else {
        flag = GIDSignIn.sharedInstance().handle(url)
       }
        return flag
    }
}

extension AppDelegate:MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

    }

}
//@available(iOS 13.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        let notificationType = userInfo[AnyHashable("notificationtype")] as? String
        if notificationType == "complete" {
            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
            let navigationController = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ConfirmAlertViewController"))
//            let navigationController = storyboard.instantiateViewController(withIdentifier: "ConfirmAlertViewController") as! ConfirmAlertViewController


            let strJobId  = userInfo[AnyHashable("jobId")]
            let jobId = Int(strJobId as? String ?? "0")

            UserStoreSingleton.shared.jobId = jobId
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalPresentationStyle = .overCurrentContext
            window?.rootViewController?.present(navigationController, animated: true, completion: nil)
        }

        else if notificationType == "accept" {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let navigationController = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController"))
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalPresentationStyle = .overCurrentContext
            window?.rootViewController?.present(navigationController, animated: true, completion: nil)
       }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //handle notification here
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let notificationType = userInfo[AnyHashable("notificationtype")] as? String
        if notificationType == "complete" {
            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
            let navigationController = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ConfirmAlertViewController"))
//            let navigationController = storyboard.instantiateViewController(withIdentifier: "ConfirmAlertViewController") as! ConfirmAlertViewController

            let strJobId  = userInfo[AnyHashable("jobId")]
            let jobId = Int(strJobId as? String ?? "0")

            UserStoreSingleton.shared.jobId = jobId
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalPresentationStyle = .overCurrentContext
            window?.rootViewController?.present(navigationController, animated: true, completion: nil)
        }

        else if notificationType == "accept" {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let navigationController = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController"))
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalPresentationStyle = .overCurrentContext
            window?.rootViewController?.present(navigationController, animated: true, completion: nil)
        }
        completionHandler()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // To enable full remote notifications functionality you should first register the device with your api service
        //https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/
        //notificationsHandler.handleRemoteNotification(with: userInfo)

        print(userInfo)

    }

}


