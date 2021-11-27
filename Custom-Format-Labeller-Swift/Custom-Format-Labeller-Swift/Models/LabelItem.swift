//
//  LabelItem.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 12/10/21.
//

import Foundation
import Custom_Label_Format_Swift

private enum Sizings {
    static let maximumCategories = 5
}

struct LabelItem: Identifiable {
    
    var id: String {
        currentId
    }
    
    var currentId: String = ""
    
    var itemName: String = ""
    
    var folderName: String = ""
    
    var selectedTypeIndex = 0
        
    var selectedCategoryIndexes: [Int] = [Int](repeating: 0, count: Sizings.maximumCategories)

    var numberOfCategoriesToDisplay: Int = 1
    
    var isMarked = false
    
    var numberOfSourceFiles: Int = 0
    
    var pageNumber = 0
    
    var relativePageNumber = 0
    
    var totalPageOffset: Int = 0
    
    var blockOffset: Int = 0
    

    mutating func updatePageNumber(pageNumber: Int, source: CustomFormat) {
        
        let items = source.sortedItems()
        
        if pageNumber < 0 || pageNumber >= items.count {
            return
        }
        
        self.pageNumber = pageNumber
        relativePageNumber = pageNumber % blockOffset
        totalPageOffset = pageNumber - relativePageNumber

        currentId = items.map({$0.key})[pageNumber]

        if let item = source.items[currentId] {
            loadValuesMatching(item: item)
            isMarked = item.isMarked
            itemName = item.displayName
            folderName = item.folderName ?? ""
            numberOfSourceFiles = item.subItemCount
        } else {
            selectedTypeIndex = 0
            isMarked = false
            
            selectedCategoryIndexes = selectedCategoryIndexes.map({ _ in
                return 0
            })
            
            numberOfCategoriesToDisplay = 1
            numberOfSourceFiles = 0
        }
    }
    
    mutating func loadValuesMatching(item: CustomFormatItem) {

        selectedTypeIndex = item.mediaType?.associatedIndexWithOffset(offset: 1) ?? 0
        let indexes = item.categories.map({$0.associatedIndexWithOffset(offset: 1)})
        
        selectedCategoryIndexes = selectedCategoryIndexes.enumerated().map({ (index, value) in
            return index < indexes.count ? indexes[index] : 0
        })
        
        numberOfCategoriesToDisplay = max(1, indexes.count)
    }
}
