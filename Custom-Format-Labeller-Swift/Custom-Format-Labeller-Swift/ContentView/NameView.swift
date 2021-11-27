//
//  NameView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 18/09/21.
//

import SwiftUI


private enum Sizings {
    static let padding: CGFloat = 2.0
}

private enum Strings {
    static let nameLabel = NSLocalizedString("NameView.Title", comment: "Name Label title")
    
    static let folderNameLabel = NSLocalizedString("NameView.FolderTitle", comment: "Folder Name Label title")

    static let doneEditingButtonTitle = NSLocalizedString("NameView.DoneEditingButton", comment: "Done Editing Button Title")
}

struct NameView: View {

    @Binding var name: String
            
    @Binding var folderName: String
    
    @Binding var identifier: String
    
    @Binding var numberOfFiles: Int
    
    @Binding var showEditLabel: Bool
    
    var identifierString: String {
        "\(identifier) (\(numberOfFiles))"
    }
    
    var body: some View {
        
        VStack {
            
            Text(Strings.nameLabel)
                .bold()
                .padding(.all, Sizings.padding)
            
            if showEditLabel {
                TextField(name, text: $name)
                    .padding(.all, Sizings.padding)
                
                Text(Strings.folderNameLabel)
                    .bold()
                    .padding(.all, Sizings.padding)
                
                TextField(folderName, text: $folderName)
                    .padding(.all, Sizings.padding)
                
                Button(Strings.doneEditingButtonTitle) {
                    showEditLabel = false
                }
            }
            else {
                Text(name)
                    .lineLimit(100)
                    .fixedSize(horizontal: true, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Sizings.padding)
            }
            
            Text(identifierString)
                .font(.footnote)
            
        }
    }
}
