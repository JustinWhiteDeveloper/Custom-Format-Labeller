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
        let state = LabellerViewModelObservable()
        let labelItem = state.labelItem
        let blockSize = 100
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-1", ofType: "clabel")!
        
        _ = CustomFormatLabellerViewModel(observable: state, fileAddress: file, blockOffset: blockSize)
        
        //when
        //then
        XCTAssertEqual(labelItem.pageNumber, 300)
    }

    func testLabellerViewModel_PreviousPageActionCanTransitionToThePreviousBlock() throws {
    
        //given
        let state = LabellerViewModelObservable()
        let labelItem = state.labelItem

        let blockSize = 100
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file, blockOffset: blockSize)
        
        //when
        viewModel.onNextBlockButtonClicked()
        viewModel.onPreviousButtonClicked()
        
        //then
        XCTAssertEqual(labelItem.pageNumber, 99)
        XCTAssertEqual(labelItem.relativePageNumber, 99)
        XCTAssertEqual(labelItem.totalPageOffset, 0)
    }
    
    func testLabellerViewModel_NextPageActionCanTransitionToTheNextBlock() throws {
    
        //given
        let state = LabellerViewModelObservable()
        let labelItem = state.labelItem

        let blockSize = 100
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file, blockOffset: blockSize)
        
        //when
        viewModel.onNextBlockButtonClicked()
        viewModel.onRelativePageChange(page: 99)
        viewModel.onNextButtonClicked()
        
        //then
        XCTAssertEqual(labelItem.pageNumber, 200)
        XCTAssertEqual(labelItem.relativePageNumber, 0)
        XCTAssertEqual(labelItem.totalPageOffset, 200)
    }
    
    func testLabellerViewModel_NextPageActionAtEndDoesNothing() throws {
    
        //given
        let state = LabellerViewModelObservable()
        let labelItem = state.labelItem

        let blockSize = 100
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file, blockOffset: blockSize)
        
        let numberOfItems = viewModel.observable.formattedFileNames.count
        let index = numberOfItems - 1
        let totalOffset = 1000

        //when
        viewModel.onRelativePageChange(page: index)
        viewModel.onNextButtonClicked()
        
        //then
        XCTAssertEqual(labelItem.pageNumber, index)
        XCTAssertEqual(labelItem.relativePageNumber, index % blockSize)
        XCTAssertEqual(labelItem.totalPageOffset, totalOffset)
    }
    
    
    func testLabellerViewModel_PreviousPageActionAtStartDoesNothing() throws {
    
        //given
        let state = LabellerViewModelObservable()
        let labelItem = state.labelItem

        let blockSize = 100
        
        let bundle = Bundle(for: type(of: self))
        let file = bundle.path(forResource: "Test-2", ofType: "clabel")!
        
        let viewModel = CustomFormatLabellerViewModel(observable: state, fileAddress: file, blockOffset: blockSize)
    
        //when
        viewModel.onPreviousButtonClicked()
        
        //then
        XCTAssertEqual(labelItem.pageNumber, 0)
        XCTAssertEqual(labelItem.relativePageNumber, 0)
        XCTAssertEqual(labelItem.totalPageOffset, 0)
    }
}
