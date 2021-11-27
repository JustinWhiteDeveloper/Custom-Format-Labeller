//
//  Custom_Format_Labeller_SwiftTests.swift
//  Custom-Format-Labeller-SwiftTests
//
//  Created by Justin White on 4/09/21.
//

import XCTest
@testable import Custom_Format_Labeller_Swift

class LabellerViewModelTests: XCTestCase {
    
    func testLabellerViewModel_ThreeHundredAlreadyLabelled() throws {
    
        //given
        let state = LabellerViewModelObservable(blockOffset: 100)
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-1", ofType: "clabel")!
        
        _ = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
        
        //when
        //then
        XCTAssertEqual(state.labelItem.pageNumber, 300)
    }

    func testLabellerViewModel_PreviousPageActionCanTransitionToThePreviousBlock() throws {
    
        //given
        let state = LabellerViewModelObservable(blockOffset: 100)
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
        
        //when
        viewModel.onNextBlockButtonClicked()
        viewModel.onPreviousButtonClicked()
        
        //then
        XCTAssertEqual(state.labelItem.pageNumber, 99)
        XCTAssertEqual(state.labelItem.relativePageNumber, 99)
        XCTAssertEqual(state.labelItem.totalPageOffset, 0)
    }
    
    func testLabellerViewModel_NextPageActionCanTransitionToTheNextBlock() throws {
    
        //given
        let state = LabellerViewModelObservable(blockOffset: 100)
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
        
        //when
        viewModel.onNextBlockButtonClicked()
        viewModel.onRelativePageChange(page: 99)
        viewModel.onNextButtonClicked()
        
        //then
        XCTAssertEqual(state.labelItem.pageNumber, 200)
        XCTAssertEqual(state.labelItem.relativePageNumber, 0)
        XCTAssertEqual(state.labelItem.totalPageOffset, 200)
        XCTAssertEqual(state.website, "https://www.google.com/search?q=The%20Seven%20Deadly%20Sins%20-%20%E4%B8%83%E3%81%A4%E3%81%AE%E5%A4%A7%E7%BD%AA%20imdb")

    }
    
    func testLabellerViewModel_NextPageActionAtEndDoesNothing() throws {
    
        //given
        let blockSize = 100
        let totalOffset = 1000

        let state = LabellerViewModelObservable(blockOffset: blockSize)
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
        
        //when
        let numberOfItems = viewModel.observable.formattedFileNames.count
        let lastIndex = numberOfItems - 1
        
        viewModel.onRelativePageChange(page: lastIndex)
        viewModel.onNextButtonClicked()
        
        //then
        XCTAssertEqual(state.labelItem.pageNumber, lastIndex)
        XCTAssertEqual(state.labelItem.relativePageNumber, lastIndex % blockSize)
        XCTAssertEqual(state.labelItem.totalPageOffset, totalOffset)
    }
    
    
    func testLabellerViewModel_PreviousPageActionAtStartDoesNothing() throws {
    
        //given
        let state = LabellerViewModelObservable(blockOffset: 100)
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
    
        //when
        viewModel.onPreviousButtonClicked()
        
        //then
        XCTAssertEqual(state.labelItem.pageNumber, 0)
        XCTAssertEqual(state.labelItem.relativePageNumber, 0)
        XCTAssertEqual(state.labelItem.totalPageOffset, 0)
    }
    
    func testLabellerViewModel_CopyPreviousButtonPressed_ShouldCopyValues() throws {
    
        //given
        let state = LabellerViewModelObservable(blockOffset: 100)

        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-1", ofType: "clabel")!
        let websiteLastUpdated = state.websiteLastUpdated.timeIntervalSince1970

        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
        
        //when
        viewModel.onCopyPreviousConfigurationButtonClicked()
        
        //then (assert changed)
        XCTAssertEqual(state.labelItem.selectedTypeIndex, 1)
        XCTAssertEqual(state.labelItem.numberOfCategoriesToDisplay, 1)
        XCTAssertEqual(state.labelItem.selectedCategoryIndexes, [9, 0, 0, 0, 0])
        
        //then (assert unchanged)
        XCTAssertEqual(state.labelItem.currentId, "3028891087299070427")
        XCTAssertEqual(state.labelItem.pageNumber, 300)
        XCTAssertEqual(state.labelItem.itemName, "まっしろ")
        XCTAssertEqual(state.labelItem.folderName, "まっしろ")
        XCTAssertEqual(state.labelItem.numberOfSourceFiles, 10)
        XCTAssertFalse(state.labelItem.isMarked)
        XCTAssertEqual(state.website, "https://www.google.com/search?q=%E3%81%BE%E3%81%A3%E3%81%97%E3%82%8D%20amazon%20jp")
        XCTAssertTrue(state.websiteLastUpdated.timeIntervalSince1970 > websiteLastUpdated)
    }
    
    func testLabellerViewModel_CopyPreviousButtonPressedAtFirstIndex_ShouldDoNothing() throws {

        //given
        let state = LabellerViewModelObservable(blockOffset: 100)
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
    
        //when
        viewModel.onCopyPreviousConfigurationButtonClicked()
        
        //then
        XCTAssertEqual(state.labelItem.pageNumber, 0)
        XCTAssertEqual(state.labelItem.relativePageNumber, 0)
        XCTAssertEqual(state.labelItem.totalPageOffset, 0)
        XCTAssertEqual(state.labelItem.folderName, "13 Reasons Why - 13の理由")
        XCTAssertEqual(state.labelItem.itemName, "13 Reasons Why")

    }
    
    func testLabellerViewModel_OnGoogleSearchButtonPressed_ShouldChangeWebsite() throws {
    
        //given
        let state = LabellerViewModelObservable(blockOffset: 100)

        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-1", ofType: "clabel")!
        let websiteLastUpdated = state.websiteLastUpdated.timeIntervalSince1970

        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
        
        //when
        viewModel.onGoogleSearch()
        
        //then
        XCTAssertEqual(state.website, "https://www.google.com/search?q=%E3%81%BE%E3%81%A3%E3%81%97%E3%82%8D")
        XCTAssertTrue(state.websiteLastUpdated.timeIntervalSince1970 > websiteLastUpdated)
    }
    
    func testLabellerViewModel_OnGoogleAmazonSearchButtonPressed_ShouldChangeWebsite() throws {
    
        //given
        let state = LabellerViewModelObservable(blockOffset: 100)

        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-1", ofType: "clabel")!
        let websiteLastUpdated = state.websiteLastUpdated.timeIntervalSince1970
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file)
        
        //when
        viewModel.onGoogleAmazonJpSearch()
        
        //then
        XCTAssertEqual(state.website, "https://www.google.com/search?q=%E3%81%BE%E3%81%A3%E3%81%97%E3%82%8D%20amazon%20jp")
        XCTAssertTrue(state.websiteLastUpdated.timeIntervalSince1970 > websiteLastUpdated)
    }
}

