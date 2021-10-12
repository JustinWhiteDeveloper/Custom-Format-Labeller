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
    
    var body: some View {
        WebViewWrapper(website: website)
    }
}

struct WebViewWrapper: NSViewRepresentable {
    let website: String
        
    func makeNSView(context: Context) -> WKWebView {
        let view = WKWebView()
        return view
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let url = URL(string: website) else {
            return
        }
        
        let request = URLRequest(url: url)
        nsView.load(request)
    }
}
