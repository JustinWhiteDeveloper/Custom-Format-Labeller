import Foundation
import Combine
import Custom_Label_Format_Swift
import SwiftUI

private enum Strings {
    static let select = NSLocalizedString("MainScreen.Select", comment: "Select state")
}

class LabellerViewModelObservable: ObservableObject {
    
    @Published var labelItem = LabelItem()

    @Published var website = ""
    
    @Published var websiteLastUpdated = Date()

    @Published var formattedFileNames: [String] = []
    
    @Published var categories: [String] = [Strings.select]

    @Published var types: [String] = [Strings.select]
    
    @Published var showEditNameLabel: Bool = false
    
    init(blockOffset: Int = 100) {
        labelItem.blockOffset = blockOffset
    }
}

protocol LabellerViewViewModel {
    
    var observable: LabellerViewModelObservable { get }
            
    func onSaveChangesButtonClicked()
    
    func onPreviousButtonClicked()
    
    func onNextButtonClicked()
    
    func onMarkButtonClicked()
    
    func onCopyPreviousConfigurationButtonClicked()
        
    func onGoogleSearch()
        
    func onGoogleAmazonJpSearch()
    
    func onNextBlockButtonClicked()
    
    func onPreviousBlockButtonClicked()
    
    func onRelativePageChange(page: Int)
}

class CustomFormatLabellerViewModel {

    private var customFormatValue = CustomFormat()
    
    private let fileAddress: String
    
    private var rawFileNames: [String] = []

    private let websiteSource: SuggestedWebsiteSource
    
    let observable: LabellerViewModelObservable
    
    init(observable: LabellerViewModelObservable,
         fileAddress: String,
         websiteSource: SuggestedWebsiteSource = BillingualSuggestedWebsiteSource()) {
        
        self.observable = observable
        self.fileAddress = fileAddress
        self.websiteSource = websiteSource
        
        let categoryNames = MediaCategory.allCases.map({$0.rawValue})
        observable.categories.append(contentsOf: categoryNames)
        
        let typeNames = MediaType.allCases.map({$0.rawValue})
        observable.types.append(contentsOf: typeNames)
        
        loadFileFromDisk()
    }
    
    private func loadFileFromDisk() {
        
        let formatReader = FolderCustomFormatReader()
        customFormatValue = formatReader.readFile(source: fileAddress)

        let values = customFormatValue.sortedItems()
        guard values.isEmpty == false, let currentId = values.map({$0.key}).first else {
            return
        }
        
        observable.labelItem.currentId = currentId
        
        let firstUnlabelledIndex = values.map({$0.value.isLabelled}).firstIndex(of: false) ?? 0

        updatePageNumber(pageNumber: min(values.count - 1, firstUnlabelledIndex))
        
        rawFileNames = values.map({$0.value.displayName})
    }
    
    private func updatePageNumber(pageNumber: Int) {

        let validPageNumber = pageNumber >= 0 && pageNumber < customFormatValue.items.count
        guard validPageNumber else {
            return
        }
        
        observable.labelItem.updatePageNumber(pageNumber: pageNumber, source: customFormatValue)
        
        observable.formattedFileNames = customFormatValue.sortedItems()
            .map({$0.value.displayName + ($0.value.isLabelled ? " ✔" : "") + ($0.value.isMarked ? " *!" : "")})
        
        
        let searchFile = observable.formattedFileNames[pageNumber]

        observable.website = websiteSource.urlForFilename(label: searchFile)
        observable.websiteLastUpdated = Date()
    }
}

extension CustomFormatLabellerViewModel: LabellerViewViewModel {

    func onSaveChangesButtonClicked() {
    
        var item = customFormatValue.items[observable.labelItem.currentId] ?? CustomFormatItem()
        
        let validIndex = observable.labelItem.selectedTypeIndex > 0
        if validIndex {
            item.mediaType = MediaType.valueFromIndex(index: observable.labelItem.selectedTypeIndex, offset: -1)
        }
        
        item.categories = observable.labelItem.selectedCategoryIndexes.filter({$0 > 0})
                            .map({MediaCategory.valueFromIndex(index: $0, offset: -1)})
        
        item.isMarked = observable.labelItem.isMarked

        let nameHasChanged = !observable.labelItem.itemName.isEmpty && observable.labelItem.itemName != item.displayName
        if nameHasChanged {
            item.name = observable.labelItem.itemName
        }
        
        customFormatValue.items.updateValue(item, forKey: observable.labelItem.currentId)
        
        let contentReader: CustomFormatWriter = FolderCustomFormatWriter()
        contentReader.writeFile(destination: fileAddress,
                                value: customFormatValue)
    }
    
    func onPreviousButtonClicked() {
        onSaveChangesButtonClicked()
        
        let pageNumber = max(0, observable.labelItem.pageNumber - 1)
        
        updatePageNumber(pageNumber: pageNumber)
    }
    
    func onNextButtonClicked() {
        onSaveChangesButtonClicked()
        
        let numberOfItems = observable.formattedFileNames.count
        
        let newPageNumber = min(numberOfItems - 1, observable.labelItem.pageNumber + 1)
        
        if newPageNumber > 0 {
            updatePageNumber(pageNumber: newPageNumber)
        }
    }
    
    func onMarkButtonClicked() {
        observable.labelItem.isMarked = !observable.labelItem.isMarked
        onSaveChangesButtonClicked()
    }
    
    func onCopyPreviousConfigurationButtonClicked() {
        let previousPageNumber = observable.labelItem.pageNumber - 1
        
        if previousPageNumber < 0 {
            return
        }
        
        let previousIdentity = customFormatValue.sortedItems().map({$0.value})[previousPageNumber]
        
        observable.labelItem.loadValuesMatching(item: previousIdentity)
    }
    
    func onGoogleSearch() {
        let label = rawFileNames[(observable.labelItem.pageNumber)]
        
        observable.website = websiteSource.googleSearchUrlForFilename(label:label)
        observable.websiteLastUpdated = Date()
    }
    
    func onGoogleAmazonJpSearch() {
        let label = rawFileNames[(observable.labelItem.pageNumber)]

        observable.website = websiteSource.googleAmazonSearchUrlForFilename(label: label)
        observable.websiteLastUpdated = Date()
    }

    func onNextBlockButtonClicked() {
        updatePageNumber(pageNumber:observable.labelItem.pageNumber + observable.labelItem.blockOffset)
    }
    
    func onPreviousBlockButtonClicked() {
        updatePageNumber(pageNumber:observable.labelItem.pageNumber - observable.labelItem.blockOffset)
    }
    
    func onRelativePageChange(page: Int) {
        let pageNumber = page + observable.labelItem.totalPageOffset
        
        updatePageNumber(pageNumber: pageNumber)
    }
}
