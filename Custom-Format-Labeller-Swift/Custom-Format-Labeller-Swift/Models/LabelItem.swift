//
//  LabelItem.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 12/10/21.
//

import Foundation
import Custom_Label_Format_Swift

struct LabelItem: Identifiable {
    
    var id: String {
        currentId
    }
    
    var currentId: String = ""
    
    var itemName: String = ""
    
    var selectedTypeIndex = 0
        
    var selectedCategoryIndexes: [Int] = [0,0,0,0,0]

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
            numberOfSourceFiles = item.subItemCount
        } else {
            selectedTypeIndex = 0
            isMarked = false
            selectedCategoryIndexes = [0,0,0,0,0]
            numberOfCategoriesToDisplay = 1
            numberOfSourceFiles = 0
        }
    }
    
    mutating func loadValuesMatching(item: CustomFormatItem) {

        selectedTypeIndex = item.mediaType?.associatedIndexWithOffset(offset: 1) ?? 0
        let indexes = item.categories.map({$0.associatedIndexWithOffset(offset: 1)})
        
        selectedCategoryIndexes = [0,0,0,0,0]

        for (index,item) in indexes.enumerated() {
            selectedCategoryIndexes[index] = item
        }

        numberOfCategoriesToDisplay = max(1, indexes.count)
    }
}
