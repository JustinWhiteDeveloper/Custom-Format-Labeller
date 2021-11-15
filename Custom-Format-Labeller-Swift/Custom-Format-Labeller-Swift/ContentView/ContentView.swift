//
//  ContentView.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 4/09/21.
//

import SwiftUI
import Custom_Label_Format_Swift

enum ScreenState {
    case selectLabelFiles
    case labelContent
}

private enum Sizings {
    static let standardPadding: CGFloat = 20.0
    
    static let websiteSize = CGSize(width: 800, height: 800)
}

private enum Strings {
    static let nextBlock = NSLocalizedString("MainScreen.nextBlock", comment: "Next Block Button")
    
    static let previousBlock = NSLocalizedString("MainScreen.previousBlock", comment: "Previous Block Button")
}

struct LabellerView: View {
    
    private let viewModel: LabellerViewViewModel
    
    @ObservedObject var observable: LabellerViewModelObservable
    
    @Binding var viewState: ScreenState
    
    public init(viewModel: LabellerViewViewModel, viewState: Binding<ScreenState>) {
        self.viewModel = viewModel
        self.observable = viewModel.observable
        self._viewState = viewState
    }

    var rangeLabelText: String {
        "\(observable.labelItem.totalPageOffset) - \(observable.labelItem.totalPageOffset + Constants.blockOffset)"
    }
    
    var body: some View {

        if (observable.formattedFileNames.isEmpty) {
            LoadingView()
        }
        else {
            HStack {
                VStack {
                    
                    ItemNavigationView(pageNumber: $observable.labelItem.relativePageNumber,
                                       textLabels: $observable.formattedFileNames,
                                       totalOffset: $observable.labelItem.totalPageOffset,
                                       numberOfItemsToDisplay: Constants.blockOffset,
                                       backButtonClicked: {
                                            viewState = .selectLabelFiles
                                       },
                                       previousButtonClicked: {
                                            viewModel.onPreviousButtonClicked()
                                       }, nextButtonClicked: {
                                            viewModel.onNextButtonClicked()
                                       }
                    ).onChange(of: observable.labelItem.relativePageNumber, perform: { value in
                        viewModel.onRelativePageChange(page: value)
                    })
                    .padding(.vertical,
                             Sizings.standardPadding)

                    VStack {
                    
                        NameView(name: $observable.labelItem.itemName,
                                 identifier: $observable.labelItem.currentId,
                                 numberOfFiles: $observable.labelItem.numberOfSourceFiles,
                                 showEditLabel: $observable.showEditNameLabel).onTapGesture {
                                    observable.showEditNameLabel = true
                                 }
                        
                        TypeView(typeIndex: $observable.labelItem.selectedTypeIndex,
                                 types: $observable.types)
                        
                        CategoryView(categoryNames: $observable.categories,
                                     categoriesToDisplay: $observable.labelItem.numberOfCategoriesToDisplay,
                                     indexes: $observable.labelItem.selectedCategoryIndexes)
                        
                    }.padding(.horizontal,
                              Sizings.standardPadding)
                    
                    BottomToolsView(isMarked: $observable.labelItem.isMarked,
                                   markButtonClicked: {
                                        viewModel.onMarkButtonClicked()
                                   }, saveButtonClicked: {
                                        viewModel.onSaveChangesButtonClicked()
                                   }, nextButtonClicked: {
                                        viewModel.onNextButtonClicked()
                                   }, googleButtonClicked: {
                                        viewModel.onGoogleSearch()
                                   }, amazonJPButtonClicked: {
                                        viewModel.onGoogleAmazonJpSearch()
                                   }, copyPreviousButtonClicked: {
                                        viewModel.onCopyPreviousConfigurationButtonClicked()
                                   }
                    )
                
                    HStack {
                        Button(Strings.previousBlock) {
                            viewModel.onPreviousBlockButtonClicked()
                        }.padding(.leading)
                        
                        Text(rangeLabelText)
                        
                        Button(Strings.nextBlock) {
                            viewModel.onNextBlockButtonClicked()
                        }.padding(.trailing)

                    }.padding()
                }
                
                WebView(website: $observable.website)
                    .frame(size: Sizings.websiteSize)
            }
        }
    }
}

struct ContentView: View {
    
    @State private var viewState = ScreenState.selectLabelFiles

    private var observable: LabellerViewModelObservable {
        LabellerViewModelObservable(blockOffset: Constants.blockOffset)
    }
    
    var body: some View {
        switch viewState {
        case .selectLabelFiles:
            FilePickerView(viewState: $viewState)
        default:
            LabellerView(viewModel: CustomFormatLabellerViewModel(observable: observable,
                                                                  fileAddress: FilePickerView.labelFile),
                         viewState: $viewState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
