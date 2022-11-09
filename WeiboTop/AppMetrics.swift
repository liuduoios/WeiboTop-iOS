//
//  AppMetrics.swift
//  WeiboTop
//
//  Created by liuduo on 2022/11/9.
//

import Foundation
import MetricKit

class AppMetrics: NSObject, MXMetricManagerSubscriber {
    
    override init() {
        super.init()
        let shared = MXMetricManager.shared
        shared.add(self)
    }
    
    deinit {
        let shared = MXMetricManager.shared
        shared.remove(self)
    }
    
    func didReceive(_ payloads: [MXMetricPayload]) {
        
    }
    
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        
    }
}
