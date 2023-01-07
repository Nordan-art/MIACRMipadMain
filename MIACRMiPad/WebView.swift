//
//  WebView.swift
//  MIACRMiPad
//
//  Created by Danik on 29.12.22.
//
import Foundation
import SwiftUI
import WebKit
import PushKit
import UserNotifications

//URL data store for webview
class WebViewData: ObservableObject {
    @Published var url: URL?
    
    init(url: URL) {
        self.url = url
    }
}

//Main func of webview
struct WebView: UIViewRepresentable {
    @ObservedObject var data: WebViewData
    
    func makeUIView(context: Context) -> WKWebView {
        return context.coordinator.webView
    }
    
    func updateUIView(_ UIView: WKWebView, context: Context) {
        if let url = data.url {
            let request = URLRequest(url: url)
            UIView.load(request)
            UIView.allowsBackForwardNavigationGestures = true;
        }
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator(data: data)
    }
}

///    Тут можно закрыть стракт вебвью, для разделения стракта и класса координатора
//     Coordinator of webview
class WebViewCoordinator: NSObject, ObservableObject, WKUIDelegate, WKNavigationDelegate, WKDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    @ObservedObject var data: WebViewData
    
    let documentInteractionController = UIDocumentInteractionController()
    
    var loadedUrl: URL? = nil
    
    var webView: WKWebView = WKWebView()
        
    init(data: WebViewData) {
        self.data = data
        
        super.init()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    //    this function uses when neew to open new page, new tab or browser
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let navURL: String = String(describing: navigationAction.request.url!)
             print(navURL)
         if ( navURL.contains("cloudmcg.quickconnect.to")) {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url)
                return nil
            }
        } else if (navURL.contains("webstationmcg.quickconnect.to")) {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url)
                return nil
            }
        } else if (navURL.contains("web-crm")) {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url)
                return nil
            }
        }
        else if navigationAction.targetFrame == nil {
            print("==== ==== ==== ====")
            print(navURL)
            UIApplication.shared.open(URL(string: navURL)!)
//            UIApplication.shared.open(URL(string: navURL)!)
            
        }
//        else if navigationAction.targetFrame == nil {
//            stateContent.url = navigationAction.request.url!
//            let activity = NSUserActivity(activityType: "newWindow")
//            activity.targetContentIdentifier = "newWindow" // IMPORTANT
//            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil)
//            stateContent.url = URL(string: "https://crm.mcgroup.pl/")!
//        }
    
        return nil
    }
    
//    Open panel for load files
//    func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
//        let openPanel = NSOpenPanel()
//        openPanel.canChooseFiles = true
//        openPanel.begin { (result) in
//            if result == NSApplication.ModalResponse.OK {
//                if let url = openPanel.url {
//                    completionHandler([url])
//                }
//            } else if result == NSApplication.ModalResponse.cancel {
//                completionHandler(nil)
//            }
//        }
//    }
    
    //    Remember user, set title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let compaire = URL(string: "https://crm.mcgroup.pl/login")
//        SendToPrintFile().setNewUrlToPrint(newUrl: webView.url)
                        
        if(webView.url == compaire){
            //            get user from inputs and save them
            webView.evaluateJavaScript(setDataL, in: nil, in: .defaultClient) { result in
                switch result {
                case .success(_):
                    ()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            //            Get user data and set to inputs
            webView.evaluateJavaScript(getDataL, in: nil, in: .defaultClient) { result in
                switch result {
                case .success(_):
                    ()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        //        Set title of page
//        webView.evaluateJavaScript("document.title") { (result, error) in
//            if error == nil {
//                self.webView.window!.title =  String(describing: result!)
//                self.webView.window!.update()
//            }
//        }
    }
    
//    File Download function
//    this function use when link/button/action deffined like download action
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
//        do {
//            // Get the document directory url
//            let documentDirectory = try FileManager.default.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            )
//            print("documentDirectory", documentDirectory.path)
//            // Get the directory contents urls (including subfolders urls)
//            let directoryContents = try FileManager.default.contentsOfDirectory(
//                at: documentDirectory,
//                includingPropertiesForKeys: nil
//            )
//            print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
//            for url in directoryContents {
//                print(url.localizedName ?? url.lastPathComponent)
//            }
//
//            // if you would like to hide the file extension
//            for var url in directoryContents {
//                url.hasHiddenExtension = true
//            }
//            for url in directoryContents {
//                print(url.localizedName ?? url.lastPathComponent)
//            }
//
//            // if you want to get all mp3 files located at the documents directory:
//            let mp3s = directoryContents.filter(\.isMP3).map { $0.localizedName ?? $0.lastPathComponent }
//            print("mp3s:", mp3s)
        
//        } catch {
//            print(error)
//        }
        
        print("1")
        let checkURL: String = String(describing: navigationAction.request.url!)
        if navigationAction.shouldPerformDownload {
            decisionHandler(.download, preferences)
        } else {
            if (checkURL.contains(".HEIC") || checkURL.contains(".doc") || checkURL.contains(".docx") || checkURL.contains(".xml")) {
                decisionHandler(.download, preferences)
                return
            }
            decisionHandler(.allow, preferences)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.canShowMIMEType {
            decisionHandler(.allow)
        } else {
            decisionHandler(.download)
        }
    }
    
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
        
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = self
    }
    
    //    File Download function
//    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
//        var fileIndex = 0
//        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
//        let url = documentsUrl.appendingPathComponent(suggestedFilename)
//
//        let fileName = suggestedFilename.components(separatedBy: ".")[0]
//        let fileTypeSecond = suggestedFilename.components(separatedBy: ".")[1]
//        let fileType = response.mimeType?.components(separatedBy: "/")[1]
//
//        var fileDownload: URL! = documentsUrl.appendingPathComponent("\(fileName).\(fileType!)")
//        var fileDownloadNoType: URL! = documentsUrl.appendingPathComponent("\(fileName).\(fileTypeSecond)")
//
//        if (FileManager.default.fileExists(atPath: fileDownload.path) || FileManager.default.fileExists(atPath: fileDownloadNoType.path)) {
//            print("1")
//            sendNotifAfterDownload(sendDown: url, fileName: suggestedFilename)
//            if (fileType! != "octet-stream" ) {
//                repeat {
//                    fileIndex += 1
//                    fileDownload = documentsUrl.appendingPathComponent("\(fileName)_\(fileIndex).\(fileType!)")
//                } while FileManager.default.fileExists(atPath: fileDownload.path)
//                completionHandler(fileDownload)
//            } else {
//                repeat {
//                    fileIndex += 1
//                    fileDownloadNoType = documentsUrl.appendingPathComponent("\(fileName)_\(fileIndex).\(fileTypeSecond)")
//                } while FileManager.default.fileExists(atPath: fileDownloadNoType.path)
//                completionHandler(fileDownloadNoType)
//            }
//        } else {
//            print("2")
//            print("fileDownloadNoType: \(fileDownloadNoType)")
//            print("fileDownload \(fileDownload)")
//            sendNotifAfterDownload(sendDown: url, fileName: suggestedFilename)
//            if (fileType! == "octet-stream" ) {
//                completionHandler(fileDownloadNoType)
//            } else {
//                completionHandler(fileDownload)
//            }
//        }
//    }
    
    func getDocumentsDirectory() -> URL { // returns your application folder
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        var fileIndex = 0
        
//        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsUrl.appendingPathComponent(suggestedFilename)

        let fileName = suggestedFilename.components(separatedBy: ".")[0]
        let fileTypeSecond = suggestedFilename.components(separatedBy: ".")[1]
        let fileType = response.mimeType?.components(separatedBy: "/")[1]
        
        var fileDownload: URL! = documentsUrl.appendingPathComponent("\(fileName).\(fileType!)")
        var fileDownloadNoType: URL! = documentsUrl.appendingPathComponent("\(fileName).\(fileTypeSecond)")
                
        let path = getDocumentsDirectory().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
        let docFolderUrl = URL(string: path)!
        
        if (FileManager.default.fileExists(atPath: fileDownload.path) || FileManager.default.fileExists(atPath: fileDownloadNoType.path)) {
            print("111")
//            sendNotifAfterDownload(sendDown: url, fileName: suggestedFilename)
            if (fileType! != "octet-stream" ) {
                repeat {
                    fileIndex += 1
                    fileDownload = documentsUrl.appendingPathComponent("\(fileName)_\(fileIndex).\(fileType!)")
                } while FileManager.default.fileExists(atPath: fileDownload.path)
                    
//                URLSession.shared.downloadTask(with: response.url!) { (tempFileUrl, response, error) in
//                        if let imageTempFileUrl = tempFileUrl {
//                            do {
//                                let data = try Data(contentsOf: imageTempFileUrl)
//                                try data.write(to: fileDownload)
//                                print("========================")
//                                print(documentsUrl)
//                                print(fileDownload!)
//                            } catch {
//                                print("Error: ")
//                                print(error)
//                            }
//                        }
//                    }.resume()
                                
                completionHandler(fileDownload)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if let sharedUrl = URL(string: "shareddocuments://\(fileDownload.path)") {
                        if UIApplication.shared.canOpenURL(sharedUrl) {
                            print("open: 1")
                            print(docFolderUrl)
                            print(sharedUrl)
                            UIApplication.shared.open(sharedUrl, options: [:], completionHandler: nil)
//                            UIApplication.shared.open(sharedUrl)
//                            UIApplication.shared.open(docFolderUrl)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                print("hui: 1")
//                                UIApplication.shared.open(sharedUrl, options: [:])
//                            }
                        }
                    }
                            }
            } else {
                repeat {
                    fileIndex += 1
                    fileDownloadNoType = documentsUrl.appendingPathComponent("\(fileName)_\(fileIndex).\(fileTypeSecond)")
                } while FileManager.default.fileExists(atPath: fileDownloadNoType.path)
                
                completionHandler(fileDownloadNoType)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        if let sharedUrl = URL(string: "shareddocuments://\(fileDownloadNoType.path)") {
                        if UIApplication.shared.canOpenURL(sharedUrl) {
                            print("open: 2")
                            print(docFolderUrl)
                            print(sharedUrl)
                            UIApplication.shared.open(sharedUrl, options: [:], completionHandler: nil)
//                            UIApplication.shared.open(sharedUrl)
//                            UIApplication.shared.open(docFolderUrl)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                print("hui: 2")
//                                UIApplication.shared.open(sharedUrl, options: [:])
//                            }
                        }
                    }
                            }
            }
        } else {
            
            print("222")
//            sendNotifAfterDownload(sendDown: url, fileName: suggestedFilename)
            if (fileType! == "octet-stream" ) {
                completionHandler(fileDownloadNoType)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if let sharedUrl = URL(string: "shareddocuments://\(fileDownloadNoType.path)") {
                        if UIApplication.shared.canOpenURL(sharedUrl) {
                            print("open: 3")
                            print(docFolderUrl)
                            print(sharedUrl)
                            UIApplication.shared.open(sharedUrl, options: [:], completionHandler: nil)
//                            UIApplication.shared.open(sharedUrl)
//                            UIApplication.shared.open(docFolderUrl)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                print("hui: 3")
//                                UIApplication.shared.open(sharedUrl, options: [:])
//                            }
                        }
                    }
                            }
            } else {
                completionHandler(fileDownload)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if let sharedUrl = URL(string: "shareddocuments://\(fileDownload.path)") {
                        if UIApplication.shared.canOpenURL(sharedUrl) {
                            print("open: 4")
                            print(docFolderUrl)
                            print(sharedUrl)
                            UIApplication.shared.open(sharedUrl, options: [:], completionHandler: nil)
//                            UIApplication.shared.open(sharedUrl)
//                            UIApplication.shared.open(docFolderUrl)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                print("hui: 4")
//                                UIApplication.shared.open(sharedUrl, options: [:])
//                            }
                        }
                    }
                            }
            }
        }
    }
    
//    Here i can write all what need to use after end of download process
    func downloadDidFinish(_ download: WKDownload) {
        print("download was ended")
//        UIApplication.shared.open(
//            URL(string: "shareddocuments:///var/mobile/Containers/Data/Application/0F5B677F-02E5-4F62-A735-A511684DEA85/Documents/ZUS-20221229103412_6.pdf")!, options: [:])
    }
}

// global veriable to set
extension WKWebView {
//extension WKWebView {
    @objc func LoadBack(_ sender: Any) {
        self.goBack()
    }
    
    @objc func Reload(_ sender: Any) {
        self.reload()
    }
    
    @objc func goHome(_ sender: Any) {
        self.load( URLRequest(url: URL(string:  "https://crm.mcgroup.pl/")!))
    }
}

extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var isMP3: Bool { typeIdentifier == "public.mp3" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}

// Function notification of download
func sendNotifAfterDownload(sendDown:URL, fileName:String) {
    let center = UNUserNotificationCenter.current()
    // create content
    let content = UNMutableNotificationContent()
    content.title = "File downloaded"
    content.body = fileName
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = NotificationCategory.general.rawValue
    content.userInfo = ["customData": "Some Data"]

    // create trigger
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)

    // create request
    let request = UNNotificationRequest(identifier: "Identifire", content: content, trigger: trigger)

    // add
    center.add(request) { error in
        if let error = error {
            print(error)
        }
    }
}

