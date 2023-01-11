//
//  DetailsTransactionViewController.swift
//  TransactionsApp
//
//  Created by Behnam on 12/26/22.
//

import UIKit

class TransactionDetailsViewController: UIViewController {
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(hexCode: "#47C690")
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor(hexCode: "#34353C")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "#FAFAFA")
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    private let viewModel: TransactionDetailsViewModel
    
    // MARK: - LifeCycle
    init(_ viewModel: TransactionDetailsViewModel) {
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
        setupValues()
    }
    
    // MARK: - Function
    func configViewController() {
        view.backgroundColor = .white
    }
    
    func addViews() {
        view.addSubview(amountLabel)
        view.addSubview(bottomView)
        bottomView.addSubview(descLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bottomView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 32),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            descLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
        ])
    }
    
    private func setupValues() {
        let transaction = viewModel.transaction
        let amount = transaction.transactionDetail.amount
        let currency = transaction.transactionDetail.currency
        
        title = transaction.partnerDisplayName
        amountLabel.text = "\(amount) \(currency.uppercased())"
        descLabel.text = transaction.transactionDetail.description
    }
}
