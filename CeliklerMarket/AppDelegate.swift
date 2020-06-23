//
//  AppDelegate.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 1.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import CoreData
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().isAutoInitEnabled = true
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            UserDefaults.standard.set(result.token, forKey: "token")
            UserDefaults.standard.synchronize()
          }
        }
        
        Messaging.messaging().subscribe(toTopic: "genel") { error in
          print("Subscribed to weather topic")
        }
        Messaging.messaging().subscribe(toTopic: "/topics/genel") { error in
          print("Subscribed to weather topic")
        }
        
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        rememberUser()
        return true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
    {
        //Handle the notification
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound,
             UNNotificationPresentationOptions.badge])
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        /*if let aps = userInfo["aps"] as? NSDictionary {
            let body_notifica = aps["alert"]! as! NSDictionary
            let title = body_notifica["title"]! as! String
            let body = body_notifica["body"]! as! String
            var image = userInfo["image"] as! String
            image =  "https://amasyaceliklermarket.com" + image
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let newCard = NSEntityDescription.insertNewObject(forEntityName: "Notifications", into: context)
            newCard.setValue(title, forKeyPath: "title")
            newCard.setValue(body, forKey: "body")
            newCard.setValue(image, forKey: "image")
            do {
                try context.save()
            } catch {
                print(error)
            }
            print("ust " + "\(userInfo)")
        }*/
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == UIApplication.State.inactive || application.applicationState == UIApplication.State.background{
            let board  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar =  board.instantiateViewController(withIdentifier: "tabBarViewController") as! UITabBarController
            tabbar.selectedIndex = 3
            window?.rootViewController = tabbar
        }
    
        if userInfo["title"] != nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let newCard = NSEntityDescription.insertNewObject(forEntityName: "Notifications", into: context)
            var image = userInfo["image"] as! String
            image =  "https://amasyaceliklermarket.com" + image
            newCard.setValue(userInfo["title"], forKeyPath: "title")
            newCard.setValue(userInfo["message"], forKey: "body")
            newCard.setValue(image, forKey: "image")
            do {
                try context.save()
            } catch {
                print(error)
            }
            let content = UNMutableNotificationContent()
            content.title = userInfo["title"] as! String
            content.body =  userInfo["message"] as! String
            content.sound = UNNotificationSound.default
            
            /*let url = URL(string: image)
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                           let myImage = UIImage(data: data)!
                            
                        }
                    }
                }
            }*/
            let identifier = "FirstUserNotification"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    print("Something wrong")
                }
            }
            
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: "token")
        UserDefaults.standard.synchronize()
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func rememberUser() {
        let user : String? =  UserDefaults.standard.string(forKey: "username")
        if user != nil  {
            let board  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar =  board.instantiateViewController(withIdentifier: "tabBarViewController") as! UITabBarController
            window?.rootViewController = tabbar
        }
    }
    
    func romoveUser() {
        let user : String? =  UserDefaults.standard.string(forKey: "username")
        if user == nil  {
            let board  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar =  board.instantiateViewController(withIdentifier: "signInController") as! UIViewController
            window?.rootViewController = tabbar
        }
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    /*func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
        completionHandler(.alert)
    }*/
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      /*if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }*/

      // Print full message.
      print("dddddd" + "\(userInfo)")

      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      // Print message ID.
      /*if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }*/

      // Print full message.
      print(userInfo)

      completionHandler()
    }
}

extension UNNotificationAttachment {

    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            let imageData = UIImage.pngData(image)
            try imageData()?.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        
        return nil
    }
}



