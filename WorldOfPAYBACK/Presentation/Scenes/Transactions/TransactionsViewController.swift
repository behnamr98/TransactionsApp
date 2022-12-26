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
        return collectionView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        return view
    }()
    
    private lazy var sumTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(hexCode: "#34353C")
        label.text = "Sum"
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(hexCode: "#34353C")
        return label
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var disposeBag = DisposeBag()
    private var viewModel: TransactionsViewModel
    
    init(_ viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
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
        indicator.startAnimating()
        configCollectionView()
    }

    private func addViews() {
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        view.addSubview(indicator)
        bottomView.addSubview(sumTitleLabel)
        bottomView.addSubview(sumLabel)
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
            
            sumTitleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 12),
            sumTitleLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            sumLabel.centerYAnchor.constraint(equalTo: sumTitleLabel.centerYAnchor),
            sumLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16)
        ]
        
        print(view.safeAreaInsets.bottom)
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    private func configCollectionView() {
        collectionView.register(cellWithClass: TransactionCell.self)
        collectionView.delegate = self
    }
    
    private func binding() {
        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.sumOfTransaction
            .bind(to: sumLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.transactions
            .bind(to: collectionView.rx.items) { collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withClass: TransactionCell.self, for: indexPath)
                cell.item = element
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func routeToDetails(_ transaction: Transaction) {
        let viewModel = TransactionDetailsViewModelImpl(transaction: transaction)
        let vc = TransactionDetailsViewController(viewModel)
        navigationController?.pushViewController(vc, animated: true)
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
