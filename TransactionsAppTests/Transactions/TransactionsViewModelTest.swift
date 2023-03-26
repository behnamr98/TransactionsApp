//
//  TransactionsViewModelTest.swift
//  TransactionsAppTests
//
//  Created by Behnam on 3/26/23.
//

import XCTest
import RxSwift
@testable import TransactionsApp
import RxTest
import RxCocoa


class TransactionsViewModelTest: XCTestCase {
    
    var viewModel: TransactionsViewModelImpl!
    var transactionsUseCase: MockGetTransactionsUseCase!
    var updateCategoriesUseCase: MockUpdateSelectedCategoriesUseCase!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        transactionsUseCase = MockGetTransactionsUseCase()
        updateCategoriesUseCase = MockUpdateSelectedCategoriesUseCase()
        viewModel = TransactionsViewModelImpl(transactionsUseCase: transactionsUseCase,
                                              updateCategories: updateCategoriesUseCase)
    }
    
    override func tearDown() {
        disposeBag = nil
        transactionsUseCase = nil
        updateCategoriesUseCase = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchTransactionsSuccess() {
        let expectedTransactions: [Transaction] = [
            .init(category: 1, amount: 10, currency: "USD"),
            .init(category: 2, amount: 20, currency: "EUR"),
        ]
        transactionsUseCase.fetchResult = .success(expectedTransactions)
        
        let isLoadingObserver = PublishSubject<Bool>()
//        viewModel.isLoading.subscribe(isLoadingObserver).disposed(by: disposeBag)
        
//        viewModel.fetchTransactions()
        
        var isVisible: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
        let recorder = ReplaySubject<Bool>.create(bufferSize: 2)
        isVisible.subscribe(recorder)

        // Emit some values
        isVisible.onNext(true)
        isVisible.onNext(false)
        recorder.toArray().subscribe { results in
            
        }
//        XCTAssertEqual(recorder.toArray(), [true, false])

        // Subscribe to the recorder to access the collected values
        let disposable = recorder.subscribe(onNext: { event in
            print("recorder.subscribe: ", event)
        })

        // Dispose the subscription
        disposable.dispose()

        

        /*
        let scheduler = TestScheduler(initialClock: 0)

        let recorder = viewModel.isLoadingSubject.asObservable()*/

        /*
        let collector = RxCollector<Bool>()
                     .collect(from: isVisible.asObservable())
                isVisible.value = false
                isVisible.value = false
                isVisible.value = true
                XCTAssertEqual(collector.toArray,
                [false, false, false, true])
        
//        XCTAssertEqual(isLoadingObserver.values, [true, false])
        XCTAssertEqual(viewModel.transactions, Observable<[Transaction]>.just(expectedTransactions))
        XCTAssertFalse(viewModel.forcedError.)
        XCTAssertEqual(viewModel.sumOfTransaction, "30.0 USD")
        XCTAssertTrue(transactionsUseCase.fetchCalled)*/
    }
    
    /*func testFetchTransactionsFailure() {
        transactionsUseCase.fetchResult = .failure(MockError())
        
        let isLoadingObserver = ObservableRecorder<Bool>()
        viewModel.isLoading.subscribe(isLoadingObserver).disposed(by: disposeBag)
        let forcedErrorObserver = ObservableRecorder<Void>()
        viewModel.forcedError.subscribe(forcedErrorObserver).disposed(by: disposeBag)
        
        viewModel.fetchTransactions()
        
        XCTAssertEqual(isLoadingObserver.values, [true, false])
        XCTAssertTrue(viewModel.transactions.isEmpty)
        XCTAssertEqual(forcedErrorObserver.values, [.next(())])
        XCTAssertTrue(transactionsUseCase.fetchCalled)
    }*/
    
    func test_publishSumValue_equal30() throws {
        let expectedTransactions: [Transaction] = [
            .init(category: 1, amount: 10, currency: "USD"),
            .init(category: 2, amount: 20, currency: "USD"),
        ]
        viewModel.publishSumValue(expectedTransactions)
        
        viewModel.sumOfTransactionsSubject
            .take(1)
            .subscribe { stringValue in
                XCTAssertEqual(stringValue, "30 USD")
            }
            .disposed(by: disposeBag)
    }
    
    func test_publishSumValue_unequal30() throws {
        let expectedTransactions: [Transaction] = [
            .init(category: 1, amount: 10, currency: "USD"),
            .init(category: 2, amount: 10, currency: "USD"),
        ]
        viewModel.publishSumValue(expectedTransactions)
        
        viewModel.sumOfTransactionsSubject
            .take(1)
            .subscribe { stringValue in
                XCTAssertEqual(stringValue, "30 USD")
            }
            .disposed(by: disposeBag)
    }
    
    func testSelectedTransaction() {
        let expectedTransactions: [Transaction] = [
            .init(category: 1, amount: 10, currency: "USD"),
            .init(category: 2, amount: 20, currency: "EUR"),
        ]
        
        let selectedTransaction = viewModel.selectedTransaction(IndexPath(row: 1, section: 0))
        XCTAssertEqual(selectedTransaction, expectedTransactions[1])
    }
    
    func testFilterTransactions() {
        let categories = [
            Category(id: 1, isSelected: true),
            Category(id: 2, isSelected: false)
        ]
        
        viewModel.filterTransactions(categories)
        
        XCTAssertEqual(updateCategoriesUseCase.categories, categories)
        XCTAssertTrue(updateCategoriesUseCase.executeCalled)
    }
}

class MockGetTransactionsUseCase: GetTransactionsUseCase {
    
    var fetchCalled = false
    var fetchResult: Result<[Transaction], Error>!
    var filteredTransactions: Observable<[Transaction]> {
        if fetchCalled, case .success(let transactions) = fetchResult {
            return Observable<[Transaction]>.just(transactions)
        }
        return Observable<[Transaction]>.empty()
    }
    
    func fetch() async {
        fetchCalled = true
    }
}

class MockUpdateSelectedCategoriesUseCase: UpdateSelectedCategoriesUseCase {
    var categories: [TransactionsApp.Category] = []
    var executeCalled: Bool = false
    func execute(_ categories: [TransactionsApp.Category]) {
        executeCalled = true
        self.categories = categories
    }
}

extension Transaction {
    init(category: Int, amount: Int, currency: String) {
        let details = Details(description: nil, bookingDate: Date(), amount: amount, currency: currency)
        self.init(partnerDisplayName: "", category: category, transactionDetail: details)
    }
}
