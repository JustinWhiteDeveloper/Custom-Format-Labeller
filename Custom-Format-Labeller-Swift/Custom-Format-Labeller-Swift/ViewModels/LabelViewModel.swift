import Foundation
import Combine
import Custom_Label_Format_Swift

private enum Strings {
    static let googleSearchPrefix = "https://www.google.com/search?q="
        
    static let imdbString = "imdb"

    static let amazonJpString = "amazon jp"

    static let select = NSLocalizedString("MainScreen.Select", comment: "Select state")
}

class LabellerViewModelObservable: ObservableObject {
    
    @Published var labelItem = LabelItem()

    @Published var website = ""
    
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
        
    func onLoadGoogleSearch()
        
    func onLoadAmazonJpSearch()
    
    func onNextBlockButtonClicked()
    
    func onPreviousBlockButtonClicked()
    
    func onRelativePageChange(page: Int)
}

class CustomFormatLabellerViewModel {

    private var customFormatValue = CustomFormat()
    
    private let fileAddress: String
    
    private var rawFileNames: [String] = []

    let observable: LabellerViewModelObservable
    
    init(observable: LabellerViewModelObservable, fileAddress: String) {
        self.observable = observable
        self.fileAddress = fileAddress
        
        setup()
    }
    
    private func setup() {
        
        // Setup Files
        let formatReader = FolderCustomFormatReader()
        customFormatValue = formatReader.readFile(source: fileAddress)

        let values = customFormatValue.sortedItems()
        guard values.isEmpty == false, let currentId = values.map({$0.key}).first else {
            return
        }
        
        observable.labelItem.currentId = currentId
        
        var lastIndex = 0
        
        for file in values.map({$0.value}) {
            if file.isLabelled == false {
                break
            }
            
            lastIndex += 1
        }
        
        updatePageNumber(pageNumber: min(values.count - 1, lastIndex))
        
        rawFileNames = values.map({$0.value.displayName})
        
        // Setup Categories and Types
        let categoryNames = MediaCategory.allCases.map({$0.rawValue})
        observable.categories.append(contentsOf: categoryNames)
        
        let typeNames = MediaType.allCases.map({$0.rawValue})
        observable.types.append(contentsOf: typeNames)
    }
    
    private func updatePageNumber(pageNumber: Int) {
        
        if pageNumber < 0 || pageNumber >= customFormatValue.items.count {
            return
        }
        
        observable.labelItem.updatePageNumber(pageNumber: pageNumber, source: customFormatValue)
        
        observable.formattedFileNames = customFormatValue.sortedItems()
            .map({$0.value.displayName + ($0.value.isLabelled ? " ✔" : "") + ($0.value.isMarked ? " *!" : "")})
        
        
        let searchFile = observable.formattedFileNames[pageNumber]

        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

        let containsEnglish = searchFile.rangeOfCharacter(from: characterset) != nil

        if containsEnglish {
            let searchTerm = ("\(searchFile) \(Strings.imdbString)"
                                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
            observable.website = Strings.googleSearchPrefix + searchTerm

        } else {
            let searchTerm = ("\(searchFile) \(Strings.amazonJpString)"
                                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
            observable.website = Strings.googleSearchPrefix + searchTerm
        }
    }
}

extension CustomFormatLabellerViewModel: LabellerViewViewModel {

    func onSaveChangesButtonClicked() {
    
        var item = customFormatValue.items[observable.labelItem.currentId] ?? CustomFormatItem()
        
        if observable.labelItem.selectedTypeIndex > 0 {
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
        let previousIdentity = customFormatValue.sortedItems().map({$0.key})[observable.labelItem.pageNumber - 1]

        observable.labelItem.loadValuesMatching(identity: previousIdentity, source: customFormatValue)
    }
    
    func onLoadGoogleSearch() {
        let searchTerm = ("\(rawFileNames[(observable.labelItem.pageNumber)])"
                            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
        
        observable.website = Strings.googleSearchPrefix + searchTerm
        
    }
    
    func onLoadAmazonJpSearch() {
        let searchTerm = ("\(rawFileNames[(observable.labelItem.pageNumber)]) \(Strings.amazonJpString)"
                            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
        
        observable.website = Strings.googleSearchPrefix + searchTerm
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
