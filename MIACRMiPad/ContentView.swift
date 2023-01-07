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
    
    @State var isPicking: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                WebView(data: WebViewData(url: stateContent.url))
                
                HStack {
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(WKWebView.LoadBack(_:)), to:  nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color(.white))
                            .frame(width: 45, height: 45)
                    }
                    .frame(width: 35, height: 35)
                    
                    Divider()
                        .frame(minWidth: 1)
                        .overlay(Color.white)
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(WKWebView.LoadForward(_:)), to:  nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color(.white))
                    }
                    .frame(width: 45, height: 45)
                    
                    Divider()
                        .frame(minWidth: 1)
                        .overlay(Color.white)
                    
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(WKWebView.goHome(_:)), to:  nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "house")
                            .foregroundColor(Color(.white))
                    }
                    .frame(width: 45, height: 45)
                    
                    Divider()
                        .frame(minWidth: 1)
                        .overlay(Color.white)
                    
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
                .frame(maxHeight: 35, alignment: .bottom)
                .position(x: geometry.size.width / 2, y: geometry.size.height - 17.5)
                
            }
        }
    }
}

struct UrlData {
    static var urlToPrinter: URL? = URL(string: "https://crm.mcgroup.pl/public/uploads/tasksfiles/2022/12/01/1669907445/Faktura-446_20221201111202.pdf")
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
