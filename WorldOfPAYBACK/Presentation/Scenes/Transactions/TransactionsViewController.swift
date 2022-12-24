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
        view.backgroundColor = .white
        configCollectionView()
    }

    private func addViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    private func configCollectionView() {
        collectionView.register(cellWithClass: TransactionCell.self)
        collectionView.delegate = self
    }
    
    private func binding() {
        viewModel.transactions.bind(to: collectionView.rx.items) { collectionView, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withClass: TransactionCell.self, for: indexPath)
            cell.item = element
            return cell
        }.disposed(by: disposeBag)
    }
}

// MARK: CollectionViewLayout & UICollectionViewDelegate & DataSource
extension TransactionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Route to Details page
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        return .init(section: section)
    }
}
