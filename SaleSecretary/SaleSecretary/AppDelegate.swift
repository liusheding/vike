//
//  AppDelegate.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/7/26.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import CoreData
import DropDown
import Contacts


let APP_USER_KEY = "APP_USER_ID"
var APP_USER_ID: String?

var APP_USER: AppUser?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DropDown.startListeningToKeyboard()
        UINavigationBar.appearance().tintColor = APP_THEME_COLOR
        
        //读取用户信息
        APP_USER_ID = UserDefaults.standard.string(forKey: "APP_USER_ID")
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginID")
        if APP_USER_ID == nil {
            self.window?.rootViewController = loginVC
        } else {
            let msgcontroller = self.window?.rootViewController?.childViewControllers[2].childViewControllers[0]    as! MessageViewController
            msgcontroller.showDotOnItem()
        }
        // 微信注册
        WXApi.registerApp("wx3cd741c2be80a27d")
        // 获取
        NetworkUtils.refreshAipAccessToken()
        
        //通知类型（这里将声音、消息、提醒角标都给加上）
        let userSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        if ((UIDevice.current.systemVersion as NSString).floatValue >= 8.0) {
            //可以添加自定义categories
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue, categories: nil)
        }
        else {
            //categories 必须为nil
            JPUSHService.register(forRemoteNotificationTypes: userSettings.types.rawValue, categories: nil)
        }
        
        // 启动JPushSDK 正式发布时apsForProduction参数改为true
        JPUSHService.setup(withOption: nil, appKey: "c06a7098971e360662a2d990",channel: "AppStore", apsForProduction: false)
        
        JPUSHService.setBadge(0)
        // JPUSHService.addTags(<#T##tags: Set<String>!##Set<String>!#>, completion: <#T##JPUSHTagsOperationCompletion!##JPUSHTagsOperationCompletion!##(Int, Set<AnyHashable>?, Int) -> Void#>, seq: <#T##Int#>)
        application.applicationIconBadgeNumber = 0
        // 请求通讯录
        DispatchQueue.global(qos: .userInteractive).async {
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .notDetermined:
                CNContactStore().requestAccess(for: .contacts){succeeded, err in
                    guard err == nil && succeeded else{
                        print("sorry , can not get permission! ")
                        return
                    }
                }
            default:
                print("Not handled")
            }
        }
        // 后端加载数据字典
        DispatchQueue.global(qos: .background).async {
            NetworkUtils.requestDictionary()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url as URL!, delegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url as URL!, delegate: self)
    }
    
    //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    func onReq(_ req: BaseReq!) {
        
    }
    
    
    //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    func onResp(_ resp: BaseResp!) {
    
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //增加IOS 7的支持
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
        JPUSHService.setBadge(0)
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //可选
        NSLog("did Fail To Register For Remote Notifications With Error: \(error)")
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
        JPUSHService.setBadge(0)
        application.applicationIconBadgeNumber = 0
        
        let _ = AppUser.loadFromServer() { (user) in
            if user.status != "0" {
                Utils.alert("对不起，您的账户已被冻结或处于异常状态，暂时无法登陆，请联系您的代理商。")
                AppUser.logout()
            } else {
                AppUser.currentUser = user
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SaleSecretary")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

