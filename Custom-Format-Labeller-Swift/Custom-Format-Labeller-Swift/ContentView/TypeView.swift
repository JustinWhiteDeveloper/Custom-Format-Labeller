//
//  TypeView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 18/09/21.
//

import SwiftUI

private enum Sizings {
    static let padding: CGFloat = 10.0
}

private enum Strings {
    static let typeLabel = NSLocalizedString("TypeView.label", comment: "Type Label")
}

struct TypeView: View {
    
    @Binding var typeIndex: Int

    @Binding var types: [String]
    
    var body: some View {
        VStack {
            Text(Strings.typeLabel)
                .bold()
                .padding(.all, Sizings.padding)

            Picker(selection: $typeIndex, label: Text("")) {
                ForEach(0 ..< types.count, id: \.self) {
                   Text(types[$0])
                }
            }
        }.padding(.all, Sizings.padding)
    }
}

