//
//  BottomToolView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 18/09/21.
//

import SwiftUI

private enum Sizings {
    static let padding: CGFloat = 10.0
}

private enum Strings {
    static let googleButton = NSLocalizedString("BottomToolView.Google", comment: "Google Button")
    
    static let amazonJpButton = NSLocalizedString("BottomToolView.Amazon", comment: "Amazon JP Button")

    static let markButton = NSLocalizedString("BottomToolView.Mark", comment: "Mark Button")
    
    static let unmarkButton = NSLocalizedString("BottomToolView.Unmark", comment: "Unmark Button")
    
    static let saveButton = NSLocalizedString("BottomToolView.Save", comment: "Save Button")

    static let nextButton = NSLocalizedString("BottomToolView.Next", comment: "Next Button")
    
    static let copyPrevious = NSLocalizedString("BottomToolView.CopyPrevious", comment: "Copy Previous Button")
}

struct BottomToolsView: View {
    
    @Binding var isMarked: Bool
    
    var markButtonClicked:() -> ()

    var saveButtonClicked:() -> ()

    var nextButtonClicked:() -> ()

    var googleButtonClicked:() -> ()
    
    var amazonJPButtonClicked:() -> ()

    var copyPreviousButtonClicked:() -> ()
    
    var body: some View {
        VStack {
            HStack {
                
                Button {
                    markButtonClicked()
                } label: {
                    Text(isMarked ? Strings.unmarkButton : Strings.markButton)
                        .foregroundColor(isMarked ? Color.black : Color.red)
                }.padding(.horizontal, Sizings.padding)

                Button(Strings.saveButton) {
                    saveButtonClicked()
                }.padding(.horizontal, Sizings.padding)

                Button(Strings.nextButton) {
                    nextButtonClicked()
                }.padding(.horizontal, Sizings.padding)
                
                
            }.padding([.top], Sizings.padding)
            
            HStack {
                Button(Strings.googleButton) {
                    googleButtonClicked()
                }.padding()
                
                Button(Strings.amazonJpButton) {
                    amazonJPButtonClicked()
                }.padding()
                
                Button(Strings.copyPrevious) {
                    copyPreviousButtonClicked()
                }
            }
                
        }.padding([.top,.bottom], Sizings.padding)
    }
}


