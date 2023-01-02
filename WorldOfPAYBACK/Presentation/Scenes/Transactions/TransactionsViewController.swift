//
//  TransactionsViewController.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 11/28/22.
//

import UIKit
import RxSwift

class TransactionsViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = makeLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.refreshControl = self.refreshControl
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.isHidden = true
        return view
    }()
    
    private lazy var sumTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(hexCode: "#34353C")
        label.text = "Total Amount"
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(hexCode: "#34353C")
        return label
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        return view
    }()
    
    private var disposeBag = DisposeBag()
    private var viewModel: TransactionsViewModel
    private let makeDetailsTransactionViewController: (Transaction) -> TransactionDetailsViewController
    private let makeFilterViewController: () -> FilterOptionsViewController
    
    init(_ viewModel: TransactionsViewModel,
         _ detailsTransactionViewControllerFactory: @escaping (Transaction) -> TransactionDetailsViewController,
         _ filterViewControllerFactory: @escaping () -> FilterOptionsViewController
    ) {
        self.viewModel = viewModel
        self.makeDetailsTransactionViewController = detailsTransactionViewControllerFactory
        self.makeFilterViewController = filterViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        addViews()
        
        setupConstraints()
        binding()
        
        viewModel.fetchTransactions()
    }
    
    private func configViews() {
        title = "Transactions"
        view.backgroundColor = .white
        configCollectionView()
        addFilterButton()
    }

    private func addViews() {
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        view.addSubview(indicator)
        bottomView.addSubview(sumTitleLabel)
        bottomView.addSubview(sumLabel)
        view.addSubview(errorView)
    }
    
    private func setupConstraints() {
        let window = UIApplication.shared.windows.first!
        let bottomPadding = window.safeAreaInsets.bottom
        
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            indicator.widthAnchor.constraint(equalToConstant: 24),
            indicator.heightAnchor.constraint(equalToConstant: 24),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bottomView.heightAnchor.constraint(equalToConstant: 56 + bottomPadding),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            sumTitleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 12),
            sumTitleLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            sumLabel.centerYAnchor.constraint(equalTo: sumTitleLabel.centerYAnchor),
            sumLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    private func configCollectionView() {
        collectionView.register(cellWithClass: TransactionCell.self)
        collectionView.delegate = self
    }
    
    private func addFilterButton() {
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"),
                                           style: .plain, target: self,
                                           action: #selector(routeToFilterOption))
        filterButton.tintColor = UIColor(hexCode: "#949BAA")
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func binding() {
//        let networkSubscription = viewModel.networkAvailable
//            .observe(on: MainScheduler.instance)
//            .subscribe { status in
//                print("Network Status:", status)
//                self.collectionView.isHidden = !status
//                self.errorView.model = ErrorMessageStyles.NoConnectionStyle()
//                self.errorView.isHidden = status
//            }
        
        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { status in
                if !self.errorView.isHidden {
                    self.errorView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.forcedError
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: showServerError)
            .disposed(by: disposeBag)
        
        viewModel.sumOfTransaction
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: updateTotalValue)
            .disposed(by: disposeBag)
        
        viewModel.transactions
            .bind(to: collectionView.rx.items) { collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withClass: TransactionCell.self, for: indexPath)
                cell.item = element
                return cell
            }.disposed(by: disposeBag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: refresh)
            .disposed(by: disposeBag)
        
        errorView.button.rx.tap
            .subscribe(onNext: refresh)
            .disposed(by: disposeBag)
    }
    
    private func refresh() {
        refreshControl.endRefreshing()
        viewModel.fetchTransactions()
    }
    
    private func routeToDetails(_ transaction: Transaction) {
        let detailsViewController = self.makeDetailsTransactionViewController(transaction)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @objc private func routeToFilterOption() {
        let vc = makeFilterViewController()
        navigationController?.pushViewController(vc, animated: true)
//        viewModel.categories
//            .subscribe(onNext: { categories in
//            }).disposed(by: disposeBag)
    }
    
    private func updateTotalValue(_ total: String) {
        self.errorView.isHidden = true
        self.collectionView.isHidden = false
        self.bottomView.isHidden = false
        self.sumLabel.text = total
    }
    
    private func showServerError() {
        self.errorView.model = ErrorMessageStyles.ServerErrorStyle()
        self.errorView.isHidden = false
        self.collectionView.isHidden = true
        self.bottomView.isHidden = true
    }
}

// MARK: CollectionViewLayout & UICollectionViewDelegate & DataSource
extension TransactionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        routeToDetails(viewModel.selectedTransaction(indexPath))
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(68))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        return .init(section: section)
    }
}
