//
//  LoadingView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 18/09/21.
//

import SwiftUI

private enum Strings {
    static let loadingText = NSLocalizedString("LoadingScreen.Label", comment: "Loading screen text")
}

struct LoadingView: View {
    var body: some View {
        Text(Strings.loadingText)
            .padding()
    }
}
