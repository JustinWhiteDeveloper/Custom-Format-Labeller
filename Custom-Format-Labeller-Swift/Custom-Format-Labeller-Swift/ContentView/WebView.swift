//
//  WebView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 5/09/21.
//

import Foundation
import WebKit
import SwiftUI

struct WebView: View {
    @Binding var website: String
        
    @Binding var lastUpdated: Date

    var body: some View {
        WebViewWrapper(website: website, lastUpdated: lastUpdated)
    }
}

struct WebViewWrapper: NSViewRepresentable {
    let website: String
        
    let lastUpdated: Date
    
    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let url = URL(string: website) else {
            return
        }
        
        let request = URLRequest(url: url)
        nsView.load(request)
    }
}
