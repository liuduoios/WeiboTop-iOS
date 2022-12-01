//
//  ContentView.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import SwiftUI
import AlertToast
import Domain

struct ContentView: View {
    @AppStorage("themeMode") private var themeMode: Theme = .system
    
    var body: some View {
        TabView {
            NavigationView {
                TopList(viewModel: TopListDIContainer.makeTopsListViewModel(<#T##self: TopListDIContainer##TopListDIContainer#>))
            }
            .tabItem {
                Image(systemName: "house")
                Text("列表")
            }
            NavigationView {
                Settings()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }
        .preferredColorScheme(themeMode.colorScheme)
    }
}

struct TopList: View {
    @ObservedObject var viewModel: TopsListViewModel
    
    var body: some View {
        List(viewModel.tops) { top in
            NavigationLink(
                destination: SafariViewController(url: top.url ?? "").navigationBarTitleDisplayMode(.inline)
            ) {
                HStack(spacing: 16) {
                    switch top.index + 1 {
                    case let i where i == 1:
                        Text("\(i)").font(.title).foregroundColor(Color("First"))
                    case let i where i == 2:
                        Text("\(i)").font(.title2).foregroundColor(Color("Second"))
                    case let i where i == 3:
                        Text("\(i)").font(.title3).foregroundColor(Color("Third"))
                    default:
                        Text("\(top.index + 1)").foregroundColor(Color("Other"))
                    }
                    VStack(alignment: .leading) {
                        Text(top.hotWord ?? "")
                        Text("热度：\(top.hotWordNum)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                }
            }
        }
        .refreshable {
//            try? await viewModel.refresh()
        }
        .navigationTitle("微博热搜")
        .navigationBarTitleDisplayMode(.automatic)
        .toast(isPresenting: $viewModel.showToast) {
            AlertToast(type: .regular, title: viewModel.errorMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
