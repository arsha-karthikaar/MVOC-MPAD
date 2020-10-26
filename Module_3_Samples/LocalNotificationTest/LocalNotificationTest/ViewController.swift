//
//  ViewController.swift
//  LocalNotificationTest
//
//  Created by Neethu Krishnan on 22/09/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // List Pending Notifications
    @IBAction func didTapListPendingNotifications(_ sender: Any) {
        center.getPendingNotificationRequests { (requests) in
            print("Pending List: \(requests)")
        }
    }
    
    // Cancel a scheduled notification
    @IBAction func didTapCancel(_ sender: Any) {
        center.removePendingNotificationRequests(withIdentifiers: ["sample_1"])
        print("Cancelled notification sample_1")
    }
    
    @IBAction func didTapSchedule(_ sender: Any) {
        scheduleNotification()
    }
    
    func scheduleNotification() {
        // Handle notification schedule based on notification settings authorization status
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self.schedule()
            case .notDetermined:
                self.requestAuthorization()
            case .denied:
                print("Please enable notification from Settings")
            default:
                break
            }
        }
    }
    
    func requestAuthorization() {
        // For the first time get permission from the user
        center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            print("Permission granted: \(granted)")
            // If the user granted permission schedule notification
            if granted && error == nil {
                self.schedule()
            }
        }
    }
    
    func schedule() {
        // Prepare notification Content
        let content = UNMutableNotificationContent()
        content.title = "Test notification"
        content.subtitle = "sub title"
        content.body = "Hello Notification"
        content.badge = 12
        content.sound = .default
        content.userInfo = ["reminderID": "45ZFG12"]
 
        // Define notification trigger
        let dateComponents = DateComponents(calendar: Calendar.current, year: 2020, month: 9, day: 22, hour: 22, minute: 19)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create notification request
        let notificationRequest = UNNotificationRequest(identifier: "sample_1", content: content, trigger: trigger)
        
        // Schedule notification
        center.add(notificationRequest) { (error) in
            if error != nil {
                print("Error in scheduling notification: \(error?.localizedDescription)")
            }
        }
    }
}

