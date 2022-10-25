//
//  ContentView.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import SwiftUI
import Alamofire
import AlertToast

struct ContentView: View {
    var body: some View {
        NavigationView {
            TopList()
        }
    }
}

struct TopList: View {
    @ObservedObject var viewModel = ListViewModel()
    
    var body: some View {
        List(viewModel.tops) { top in
            NavigationLink(
                destination: WebView(url: top.url ?? "").navigationTitle(top.hotWord ?? "")
            ) {
                VStack(alignment: .leading) {
                    Text(top.hotWord ?? "")
                    Text("热度：\(top.hotWordNum)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
            }
        }
        .refreshable {
            viewModel.loadData()
        }
        .navigationTitle("微博热搜")
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
