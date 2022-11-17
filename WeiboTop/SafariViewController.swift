//
//  SafariViewController.swift
//  WeiboTop
//
//  Created by liuduo on 2022/11/17.
//

import SwiftUI
import SafariServices
import UIKit
import Infrastructure

struct SafariViewController: UIViewControllerRepresentable {
    
    let url: String
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let URL = URL(string: url.encodeQuery())!
        let vc = SFSafariViewController(url: URL)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}
