//
//  ContentView.swift
//  WeiboTop
//
//  Created by liuduo on 2022/10/24.
//

import SwiftUI
import Alamofire

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
                destination: WebView(url: top.url ?? "")
            ) {
                Text(top.hotWord ?? "")
            }
        }
        .refreshable {
            viewModel.loadData()
        }
        .navigationTitle("微博热搜")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
