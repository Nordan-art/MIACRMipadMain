//
//  ContentView.swift
//  MIACRMiPad
//
//  Created by Danik on 29.12.22.
//
import UIKit
import SwiftUI
import WebKit
import PDFKit

struct stateContent {
    static var url: URL = URL(string: "https://crm.mcgroup.pl/")!
}

struct ContentView: View {
        
    
    @State var strCheckPdf: String = UrlData.urlToPrinter!.absoluteString
    @State private var DataState = stateContent()
    
    @State private var showPreview = false // state activating preview
    @StateObject var documentController = DocumentController()
    
    @Environment(\.openWindow) private var openWindow
        
    var body: some View {
        ZStack {
            
            WebView(data: WebViewData(url: stateContent.url))
            
            HStack {
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(WKWebView.LoadBack(_:)), to:  nil, from: nil, for: nil)
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color(.white))
                }
                .frame(width: 35, height: 35)
                
                Button(action: {
//                    UIApplication.mainWindow?.windowController?.newWindowForTab(nil)
//                    let activity = NSUserActivity(activityType: "newWindow")
//                    activity.userInfo = ["some key":"some value"]
//                    activity.targetContentIdentifier = "newWindow" // IMPORTANT
//                    UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil)
//                    openWindow(id: "newWindow")
//                    self.showPreview = true
                    
                    documentController.presentDocument(url: URL(string: "file:///var/mobile/Containers/Data/Application/9021567D-9F66-42A5-BB11-158B53B811F2/Documents/2023_20230101100135_23.pdf")!)
                }) {
                    Image(systemName: "plus.app")
                        .foregroundColor(Color(.white))
                }
                .frame(width: 45, height: 45)
                                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(WKWebView.goHome(_:)), to:  nil, from: nil, for: nil)
                }) {
                    Image(systemName: "house")
                        .foregroundColor(Color(.white))
                        
                }
                .frame(width: 45, height: 45)
                
                Button(action: {
//                        SendToPrintFile().SendToPrint()
                }) {
                    Image(systemName: "printer.dotmatrix")
                        .foregroundColor(Color(.white))
                }
                .frame(width: 45, height: 45)
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(WKWebView.Reload(_:)), to:  nil, from: nil, for: nil)
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(Color(.white))
                }
                .frame(width: 45, height: 45)
            }
            .padding(.leading, 15)
            .padding(.trailing , 15)
            .background(Color(red: 100 / 255, green: 108 / 255, blue: 154 / 255).opacity(0.8))
            .cornerRadius(radius: 15.0, corners: [.topLeft, .topRight])
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
    }
}

struct UrlData {
    static var urlToPrinter: URL? = URL(string: "https://crm.mcgroup.pl/public/uploads/tasksfiles/2022/12/01/1669907445/Faktura-446_20221201111202.pdf")
}

class SendToPrintFile: UIView, PDFViewDelegate {
//class SendToPrintFile: NSView, PDFViewDelegate {
    
//    func setNewUrlToPrint(newUrl: URL?) {
//        UrlData.urlToPrinter = newUrl
//    }
//    
//    func SendToPrint(  ) {
//        let pdfView = PDFView()
//        let path = UrlData.urlToPrinter!
//        let pdfDoc = PDFDocument(url: path)
//        let wnd = NSWindow()
//        
//        pdfView.autoScales = true
//        pdfView.delegate = self
//        pdfView.displayMode = .singlePage
//        pdfView.displayDirection = .vertical
//        pdfView.document = pdfDoc
//        wnd.setFrame(CGRect(x: 0, y: 0, width: 0, height: 0), display: true, animate: true)
//        wnd.center()
//        wnd.contentView = pdfView
//        pdfView.print(with: NSPrintInfo.shared, autoRotate: true)
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}
extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

class DocumentController: NSObject, ObservableObject, UIDocumentInteractionControllerDelegate {
    let controller = UIDocumentInteractionController()
    
    func presentDocument(url: URL) {
        controller.delegate = self
        controller.url = url
        controller.presentPreview(animated: true)
    }

    func documentInteractionControllerViewControllerForPreview(_: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
}
