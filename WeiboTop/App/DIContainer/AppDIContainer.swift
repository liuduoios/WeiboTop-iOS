//
//  AppDIContainer.swift
//  WeiboTop
//
//  Created by liuduo on 2022/12/1.
//

import Foundation

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - DIContainers of scenes
    
    func makeTopsSceneDIContainer() -> TopsSceneDIContainer {
        return TopsSceneDIContainer()
    }
}
