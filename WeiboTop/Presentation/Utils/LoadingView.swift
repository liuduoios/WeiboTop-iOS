//
//  File.swift
//  
//
//  Created by liuduo on 2022/11/30.
//

import UIKit

public class LoadingView {
    
    internal static var spinner: UIActivityIndicatorView?
    
    public static func show() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }
    
    public static func hide() {
        DispatchQueue.main.async {
            guard let spinner else { return }
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.spinner = nil
        }
    }
    
    @objc public static func update() {
        DispatchQueue.main.async {
            if spinner != nil {
                hide()
                show()
            }
        }
    }
}
