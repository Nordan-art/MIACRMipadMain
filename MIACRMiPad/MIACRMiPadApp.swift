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
            
            GeometryReader{ geometry in
                ContentView()
            }
            //            .frame(minWidth: stateSizeData.minWidth, maxWidth: .infinity,
            //                   minHeight: stateSizeData.minHeight, maxHeight: .infinity,
            //                   alignment: .center)
        }
        //        .windowResizabilityContentSize()
        //        .commands {
        //            CommandGroup(replacing: .help) {
        //                Button(action: {
        //                    NSWorkspace.shared.open(URL(string:"https://miacrm.pl")!)
        //                }) {
        //                    Text("MIACRM Help")
        //                }
        //            }
        //            CommandGroup(after: .newItem) {
        //                Button(action: {
        //                    SendToPrintFile().SendToPrint()
        //                }) {
        //                    Text("Send to print")
        //                }
        //                .keyboardShortcut("p", modifiers: [.command])
        //
        //                Button(action: {
        //                    NSApp.sendAction(#selector(WKWebView.Reload(_:)), to: nil, from: nil)
        //                }) {
        //                    Text("Reload page")
        //                }
        //                .keyboardShortcut("r", modifiers: [.command])
        //            }
        //        }
        
    }
}

struct stateSizeData {
    static var minHeight: CGFloat = 500
    static var minWidth: CGFloat = 900
}

//extension Scene {
//    func windowResizabilityContentSize() -> some Scene {
//        if #available(macOS 13.0, *) {
//            return defaultSize(width: (NSScreen.main?.visibleFrame.size.width)! / 1.25, height: (NSScreen.main?.visibleFrame.size.height)! / 1.25)
//        } else {
//            return self
//        }
//    }
//}
