//
//  CategoryView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 18/09/21.
//

import SwiftUI

private enum Sizings {
    static let padding: CGFloat = 10.0
}

private enum Strings {
    static let categoryLabelTitle = NSLocalizedString("CategoryView.Title", comment: "Category Label")
    
    static let categoryAddButtonTitle = NSLocalizedString("CategoryView.AddCategoryButtonTitle", comment: "Category Add Button")

    static let categoryRemoveButtonTitle = NSLocalizedString("CategoryView.RemoveCategoryButtonTitle", comment: "Category Remove Button")
}

struct CategoryView: View {
    
    @Binding var categoryNames: [String]
    
    @Binding var categoriesToDisplay: Int
    
    @Binding var indexes: [Int]
    
    var body: some View {

        VStack {
            HStack {
                Text(Strings.categoryLabelTitle)
                    .bold()
                    .padding(.all, Sizings.padding)
                
                Button(Strings.categoryAddButtonTitle) {
                    categoriesToDisplay = min(indexes.count, categoriesToDisplay + 1)
                }
                
                Button(Strings.categoryRemoveButtonTitle) {
                    indexes[categoriesToDisplay - 1] = 0
                    categoriesToDisplay = max(1, categoriesToDisplay - 1)
                }
            }
            
            Group {
                ForEach(0..<categoriesToDisplay, id: \.self) { item in

                    Picker(selection: $indexes[item],
                           label: Text("")) {
                        ForEach(0 ..< categoryNames.count, id: \.self) {
                           Text(categoryNames[$0])
                        }
                    }
                }
            }.padding([.horizontal], Sizings.padding)
        }
    }
}
