//
//  MIACRMiPadApp.swift
//  MIACRMiPad
//
//  Created by Danik on 29.12.22.
//

import SwiftUI
import WebKit
import UserNotifications

@main
struct MIACRMiPadApp: App {
    
    private var delegate: NotificationDelegate = NotificationDelegate()
    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        
        WindowGroup {
            
                ContentView()
            
        }
    }
}
