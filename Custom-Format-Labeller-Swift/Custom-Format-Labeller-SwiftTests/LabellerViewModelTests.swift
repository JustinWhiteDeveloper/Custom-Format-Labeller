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
        let labelItem = state.labelItem
        
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
        let labelItem = state.labelItem
        
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
    }
    
    func testLabellerViewModel_NextPageActionAtEndDoesNothing() throws {
    
        //given
        let blockSize = 100
        let totalOffset = 1000

        let state = LabellerViewModelObservable(blockOffset: blockSize)
        let labelItem = state.labelItem
        
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
        XCTAssertEqual(state.labelItem.numberOfSourceFiles, 10)
        XCTAssertFalse(state.labelItem.isMarked)
    }
}

