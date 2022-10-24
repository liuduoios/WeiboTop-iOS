//
//  WebView.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let URL = URL(string: encodedUrl) {
            let request = URLRequest(url: URL)
            uiView.load(request)
        } else {
            print("\(url) 不合法")
        }
    }
}
