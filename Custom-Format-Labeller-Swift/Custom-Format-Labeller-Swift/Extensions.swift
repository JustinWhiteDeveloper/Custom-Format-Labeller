//
//  Extensions.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 15/11/21.
//

import SwiftUI

extension View {
    public func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        return frame(width: size.width, height: size.height, alignment: alignment)
    }
}
