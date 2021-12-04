//
//  FilePickerView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 5/09/21.
//

import Foundation
import SwiftUI
import Custom_Label_Format_Swift

private enum Sizings {
    static let defaultViewSize: CGSize = CGSize(width: 600, height: 400)
    
    static let standardPadding: CGFloat = 20.0
}

private enum Strings {
    static let selectLabelTitle = NSLocalizedString("FilePicker.SelectLabel", comment: "Select Label")
    
    static let createNewLabelTitle = NSLocalizedString("FilePicker.CreateNewLabel", comment: "Create New Label")

    static let fileNotFoundTitle = NSLocalizedString("FilePicker.FileNotFound", comment: "File Not Found Error")
}

struct FilePickerView: View {
    
    @Binding var viewState: ScreenState

    @State private var labelFile: String = ""
    
    @State private var newFileDirectory: String = ""
    
    static var labelFile: String = ""
    
    var body: some View {
        
        VStack {
            Text(Strings.selectLabelTitle).bold()

            FolderSelector(folder: $labelFile, action: {
                loadFiles()
            })
            .padding([.leading,.bottom,.trailing],
                     Sizings.standardPadding)
            
            Text(Strings.createNewLabelTitle).bold()

            FolderSelector(folder: $newFileDirectory, action: {
                writeNewFile()
                loadFiles()
            })
            .padding([.leading,.bottom,.trailing],
                     Sizings.standardPadding)
            
        }.padding(Sizings.standardPadding)
        .frame(size: Sizings.defaultViewSize)
    }
    
    func writeNewFile() {
        
        let folderNotFound = !FileManager.default.fileExists(atPath: newFileDirectory)
        
        if folderNotFound {
            print(Strings.fileNotFoundTitle)
            return
        }
        
        let reader = FolderCustomFormatReader()
        let value = reader.readFolder(source: newFileDirectory)
        
        let destination = "\(newFileDirectory)/\((newFileDirectory as NSString).lastPathComponent).clabel"
        
        let writer = FolderCustomFormatWriter()
        writer.writeFile(destination: destination, value: value)
        labelFile = destination
    }
    
    func loadFiles() {
        
        let filesNotFound = !FileManager.default.fileExists(atPath: labelFile)
        
        if filesNotFound {
            print(Strings.fileNotFoundTitle)
            return
        }

        FilePickerView.labelFile = labelFile
        viewState = .labelContent
    }
}
