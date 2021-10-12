//
//  ItemNavigationView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 18/09/21.
//

import SwiftUI

private enum Sizings {
    static let standardPadding: CGFloat = 20.0
    
    static let minimumPickerLength: CGFloat = 200.0
}

private enum Strings {
    static let backButton = NSLocalizedString("Navigation.Back", comment: "Back Button")

    static let previousButton = NSLocalizedString("Navigation.previousItem", comment: "Previous Button")
    
    static let nextButton = NSLocalizedString("Navigation.nextItem", comment: "Next Button")
    
    static let pickerLabel = NSLocalizedString("Navigation.PickerLabel", comment: "Picker Label")
}

struct ItemNavigationView: View {
    
    @Binding var pageNumber: Int

    @Binding var textLabels: [String]
        
    @Binding var totalOffset: Int
    
    let numberOfItemsToDisplay: Int
    
    var backButtonClicked:() -> ()
    
    var previousButtonClicked:() -> ()
    
    var nextButtonClicked:() -> ()
    
    var filteredLabelsList: [String] {
        
        let textLabelsCount = textLabels.count
        let maximumItemsToShow = min(numberOfItemsToDisplay, (textLabelsCount - totalOffset))
        
        let allTextLabels = (0 ..< textLabelsCount).map({"\($0) - \(textLabels[$0])"})
        return allTextLabels
            .prefix(numberOfItemsToDisplay + totalOffset)
            .suffix(maximumItemsToShow)
    }
    
    var body: some View {
        
        HStack {
            Button(Strings.backButton) {
                backButtonClicked()
            }
            
            Button(Strings.previousButton) {
                previousButtonClicked()
            }
            
            Picker(selection: $pageNumber,
                   label: Text(Strings.pickerLabel)) {
                
                ForEach(0 ..< filteredLabelsList.count, id: \.self) { row in
                   Text(filteredLabelsList[row])
                }
                
            }.frame(minWidth: Sizings.minimumPickerLength)
            
            Button(Strings.nextButton) {
                nextButtonClicked()
            }
            
        }.padding([.leading,.trailing,.top],
                  Sizings.standardPadding)
    }
}
