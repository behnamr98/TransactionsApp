//
//  TransactionCell.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/5/22.
//

import UIKit

class TransactionCell: UICollectionViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    var item: Transaction? {
        didSet {
            nameLabel.text = item?.partnerDisplayName
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
        contentView.addSubview(nameLabel)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)])
    }
    
    func configCell() {
        contentView.backgroundColor = UIColor(hexCode: "#F6F8F9")!
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    }
    
}
