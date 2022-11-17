//
//  OtherView.swift
//  WeiboTop
//
//  Created by liuduo on 2022/11/17.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        Form {
            ThemeModeSetting()
        }
        .navigationTitle("设置")
    }
}

enum Theme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    var id: Self { self }
    
    public var colorScheme: ColorScheme {
        switch self {
        case .system:
            return .dark
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

struct ThemeModeSetting: View {
    @State private var selectedTheme: Theme = .system {
        didSet {
            
        }
    }
    
    var body: some View {
        Picker("主题", selection: $selectedTheme) {
            Text("跟随系统").tag(Theme.system)
            Text("浅色").tag(Theme.light)
            Text("深色").tag(Theme.dark)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
