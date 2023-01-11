//
//  FilterOptionsViewController.swift
//  TransactionsApp
//
//  Created by Behnam on 12/26/22.
//

import UIKit
import RxSwift

class FilterOptionsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.collectionViewLayout = makeLayout()
        collection.register(cellWithClass: FilterOptionCell.self)
        collection.delegate = self
        return collection
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(hexCode: "#2196F3")
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(UIColor(hexCode: "#E9EDF5"), for: .normal)
        return button
    }()
    
    private let viewModel: FilterOptionsViewModel
    private let disposeBag = DisposeBag()
    
    init(_ viewModel: FilterOptionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewController()
        addViews()
        setupConstraints()
        binding()
        viewModel.getCategories()
    }
    
    private func configViewController() {
        title = "Filter Options"
        view.backgroundColor = .white
    }
    
    private func addViews() {
        view.addSubview(collectionView)
        view.addSubview(applyButton)
    }
    
    private func setupConstraints() {
        let safeView = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: -12),
            collectionView.leadingAnchor.constraint(equalTo: safeView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeView.trailingAnchor),
            
            applyButton.heightAnchor.constraint(equalToConstant: 56),
            applyButton.leadingAnchor.constraint(equalTo: safeView.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: safeView.trailingAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: safeView.bottomAnchor, constant: -12)
        ])
    }
    
    private func binding() {
        applyButton.rx
            .tap
            .subscribe(onNext: applyButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.categories
            .bind(to: collectionView.rx.items) { collectionView, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withClass: FilterOptionCell.self, for: indexPath)
                cell.item = element
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func applyButtonTapped() {
        viewModel.transferCategories()
        dismiss(animated: true)
    }
}

// MARK: - UICollectionView And Delegation
extension FilterOptionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectCategory(indexPath)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(200), heightDimension: .absolute(42))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(42))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        return .init(section: section)
    }
}
