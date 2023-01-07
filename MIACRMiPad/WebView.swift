//
//  WebView.swift
//  MIACRMiPad
//
//  Created by Danik on 29.12.22.
//
import UIKit
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
    
    @StateObject var documentController = DocumentController()
    
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
            UIApplication.shared.open(URL(string: navURL)!)
        }
        
        return nil
    }
    
    //    Remember user, set title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let compaire = URL(string: "https://crm.mcgroup.pl/login")
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
    }
    
    //    File Download function
    //    this function use when link/button/action deffined like download action
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        
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
    
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        var fileIndex = 0
        
                let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let url = documentsUrl.appendingPathComponent(suggestedFilename)
        
        let fileName = suggestedFilename.components(separatedBy: ".")[0]
        let fileTypeSecond = suggestedFilename.components(separatedBy: ".")[1]
        let fileType = response.mimeType?.components(separatedBy: "/")[1]
        
        var fileDownload: URL! = documentsUrl.appendingPathComponent("\(fileName).\(fileType!)")
        var fileDownloadNoType: URL! = documentsUrl.appendingPathComponent("\(fileName).\(fileTypeSecond)")
        
        if (FileManager.default.fileExists(atPath: fileDownload.path) || FileManager.default.fileExists(atPath: fileDownloadNoType.path)) {
//                        sendNotifAfterDownload(sendDown: url, fileName: suggestedFilename)
            if (fileType! != "octet-stream" ) {
                repeat {
                    fileIndex += 1
                    fileDownload = documentsUrl.appendingPathComponent("\(fileName)_\(fileIndex).\(fileType!)")
                } while FileManager.default.fileExists(atPath: fileDownload.path)
                
                completionHandler(fileDownload)
                documentController.presentDocument(url: fileDownload)
            } else {
                repeat {
                    fileIndex += 1
                    fileDownloadNoType = documentsUrl.appendingPathComponent("\(fileName)_\(fileIndex).\(fileTypeSecond)")
                } while FileManager.default.fileExists(atPath: fileDownloadNoType.path)
                
                completionHandler(fileDownloadNoType)
                documentController.presentDocument(url: fileDownloadNoType)
            }
        } else {
            
//            sendNotifAfterDownload(sendDown: url, fileName: suggestedFilename)
            if (fileType! == "octet-stream" ) {
                completionHandler(fileDownloadNoType)
                documentController.presentDocument(url: fileDownloadNoType)
            } else {
                completionHandler(fileDownload)
                documentController.presentDocument(url: fileDownload)
            }
        }
    }
    
    //    Here i can write all what need to use after end of download process
    func downloadDidFinish(_ download: WKDownload) {
        print("download was ended")
    }
}

// global veriable to set
extension WKWebView {
    //extension WKWebView {
    @objc func LoadBack(_ sender: Any) {
        if self.canGoBack {
            self.goBack()
        }
    }
    
    @objc func LoadForward(_ sender: Any) {
        if self.canGoForward {
            self.goForward()
        }
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

class DocumentController: NSObject, ObservableObject, UIDocumentInteractionControllerDelegate {
    let controller = UIDocumentInteractionController()
    
    func presentDocument(url: URL) {
        controller.delegate = self
        controller.url = url
        controller.presentPreview(animated: true)
    }

//    func documentInteractionControllerViewControllerForPreview(_: UIDocumentInteractionController) -> UIViewController {
//        return UIApplication.shared.windows.first!.rootViewController!
//    }

    func documentInteractionControllerViewControllerForPreview(_: UIDocumentInteractionController) -> UIViewController {
            return (UIApplication.shared.currentUIWindow()?.rootViewController)!
        }
    }

    public extension UIApplication {
        func currentUIWindow() -> UIWindow? {
            let connectedScenes = UIApplication.shared.connectedScenes
                .filter({
                    $0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})

            let window = connectedScenes.first?
                .windows
                .first { $0.isKeyWindow }

            return window
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

