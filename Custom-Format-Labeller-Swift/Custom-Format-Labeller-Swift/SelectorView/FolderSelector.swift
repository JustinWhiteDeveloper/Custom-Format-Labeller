//
//  FolderSelector.swift
//

import Foundation
import SwiftUI

private enum Strings {
    static let selectLabel = NSLocalizedString("FilePicker.SelectFile", comment: "Select Button Text")
}

struct FolderSelector: View {
    
    @Binding var folder: String
    
    @State private var folderDisplayName: String = Strings.selectLabel

    var body: some View {
        Button(folderDisplayName) {
            self.selectFolder()
        }
    }
    
    var action:() -> ()
    
    func selectFolder() {
        let folderChooserPoint = CGPoint(x: 0, y: 0)
        let folderChooserSize = CGSize(width: 500, height: 600)
        let folderChooserRectangle = CGRect(origin: folderChooserPoint, size: folderChooserSize)
        let folderPicker = NSOpenPanel(contentRect: folderChooserRectangle,
                                       styleMask: .utilityWindow,
                                       backing: .buffered,
                                       defer: true)

        folderPicker.allowsMultipleSelection = false
        folderPicker.canChooseDirectories = true
        folderPicker.canChooseFiles = true
        folderPicker.canDownloadUbiquitousContents = true
        folderPicker.canResolveUbiquitousConflicts = true

        folderPicker.begin { response in
            if response == .OK,
               let pickedFolder = folderPicker.urls.first {
                folder = pickedFolder.path
                folderDisplayName = (folder as NSString).lastPathComponent
                self.action()
            }
        }
    }
}
