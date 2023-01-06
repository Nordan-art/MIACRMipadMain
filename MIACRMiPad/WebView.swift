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
class WebViewCoordinator: NSObject, ObservableObject, WKUIDelegate, WKNavigationDelegate, WKDownloadDelegate {
    
    @ObservedObject var data: WebViewData
    
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
//        else if navigationAction.targetFrame == nil {
//            stateContent.url = navigationAction.request.url!
//            if let currentWindow = UIApplication.keyWindow,
//               let windowController = currentWindow.windowController {
//                windowController.newWindowForTab(nil)
//                if let newWindow = UIApplication.shared.mainWindow, currentWindow != newWindow {
//                    currentWindow.addTabbedWindow(newWindow, ordered: .above)
//                }
//            }
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
//    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
//        // Create destination URL
//          let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//          let destinationFileUrl = documentsUrl.appendingPathComponent(suggestedFilename)
//
//          //Create URL to the source file you want to download
//        let fileURL = response.url!
//
//          let sessionConfig = URLSessionConfiguration.default
//          let session = URLSession(configuration: sessionConfig)
//
//          let request = URLRequest(url:fileURL)
//
//          let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
//              print(request)
//              print(tempLocalUrl)
//              if let tempLocalUrl = tempLocalUrl, error == nil {
//                  // Success
//                  if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                      print("Successfully downloaded. Status code: \(statusCode)")
//                  }
//
//                  do {
//                      try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
//                      print(tempLocalUrl)
//                      print(destinationFileUrl)
//                      completionHandler(tempLocalUrl)
//                  } catch (let writeError) {
//                      print("Error creating a file \(destinationFileUrl) : \(writeError)")
//                  }
//
//              } else {
//                  print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
//              }
//          }
//          task.resume()
//    }
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
            print("111")
            sendNotifAfterDownload(sendDown: url, fileName: suggestedFilename)
            if (fileType! != "octet-stream" ) {
                repeat {
                    fileIndex += 1
                    fileDownload = documentsUrl.appendingPathComponent("\(fileName)_\(fileIndex).\(fileType!)")
                } while FileManager.default.fileExists(atPath: fileDownload.path)

                URLSession.shared.downloadTask(with: response.url!) { (tempFileUrl, response, error) in
                        if let imageTempFileUrl = tempFileUrl {
                            do {
                                let data = try Data(contentsOf: imageTempFileUrl)
                                try data.write(to: fileDownload)
                                print("========================")
                                print(response!.url!)
                                print(data)
                                print(tempFileUrl)
                                print(imageTempFileUrl)
                                print(documentsUrl)
                                print(fileDownload!)
                                print(fileDownloadNoType!)
                            } catch {
                                print("Error: ")
                                print(error)
                            }
                        }
                    }.resume()

                completionHandler(fileDownload)
            } else {
                repeat {
                    fileIndex += 1
                    fileDownloadNoType = documentsUrl.appendingPathComponent("\(fileName)_\(fileIndex).\(fileTypeSecond)")
                } while FileManager.default.fileExists(atPath: fileDownloadNoType.path)
                completionHandler(fileDownloadNoType)
            }
        } else {
            print("222")
            sendNotifAfterDownload(sendDown: url, fileName: suggestedFilename)
            if (fileType! == "octet-stream" ) {
                completionHandler(fileDownloadNoType)
            } else {
                completionHandler(fileDownload)
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
        self.goBack()
    }
    
    @objc func Reload(_ sender: Any) {
        self.reload()
    }
    
    @objc func goHome(_ sender: Any) {
        self.load( URLRequest(url: URL(string:  "https://crm.mcgroup.pl/")!))
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

