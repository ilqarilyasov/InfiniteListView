//
//  InfiniteListViewTests.swift
//  InfiniteListViewTests
//
//  Created by Ilqar Ilyasov on 8/1/24.
//

import XCTest
@testable import InfiniteListView

final class ListViewModelTests: XCTestCase {

    var viewModel: ListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ListViewModel()
    }

    func testLoadMockData() {
        viewModel.loadMockData()
        XCTAssertFalse(viewModel.items.isEmpty)
    }

    func testLoadMoreData() {
        viewModel.loadMoreData()
        XCTAssertTrue(viewModel.isLoading)

        let expectation = self.expectation(description: "Load more data")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.viewModel.items.isEmpty)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
