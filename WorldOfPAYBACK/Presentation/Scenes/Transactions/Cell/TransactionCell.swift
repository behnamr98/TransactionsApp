//
//  TransactionCell.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/5/22.
//

import UIKit

class TransactionCell: UICollectionViewCell {
    
    private lazy var iconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "#E9EDF5")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: "#34353C")
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: "#949BAA")
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: "#949BAA")
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    var item: Transaction? {
        didSet {
            guard let item = self.item else { return }
            setAmount(amount: item.transactionDetail.amount, currency: item.transactionDetail.currency)
            nameLabel.text = item.partnerDisplayName
            descLabel.text = item.transactionDetail.description
            dateLabel.text = item.transactionDetail.bookingDate.localizedFormat
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCell()
        addViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function
    func addViews() {
        contentView.addSubview(iconView)
        iconView.addSubview(arrowImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            arrowImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            arrowImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 4),
            
            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: -4),
            
            dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: amountLabel.trailingAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor)
        ])
    }
    
    func configCell() {
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    }
    
    private func setAmount(amount: Int, currency: String) {
        if amount > 0 {
            amountLabel.text = "+\(amount) \(currency.uppercased())"
            amountLabel.textColor = UIColor(hexCode: "#47C690")!
            arrowImageView.image = UIImage(systemName: "arrow.up")
        } else {
            amountLabel.text = "-\(amount) \(currency.uppercased())"
            amountLabel.textColor = UIColor(hexCode: "#F55247")!
            arrowImageView.image = UIImage(systemName: "arrow.down")
        }
        
    }
    
}
