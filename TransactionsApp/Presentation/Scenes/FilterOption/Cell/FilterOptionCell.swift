//
//  FilterOptionCell.swift
//  TransactionsApp
//
//  Created by Behnam on 12/31/22.
//

import UIKit

class FilterOptionCell: UICollectionViewCell {
    
    private lazy var checkmarkView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "checkmark")
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    var item: FilterOptionsModels.CategoryModel? {
        didSet {
            guard let item = self.item else { return }
            titleLabel.text = item.title
            setupStyles(item.selected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCell()
        addViews()
        setupConstraint()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function
    func addViews() {
        contentView.addSubview(checkmarkView)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            checkmarkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            checkmarkView.widthAnchor.constraint(equalToConstant: 14),
            checkmarkView.heightAnchor.constraint(equalTo: checkmarkView.widthAnchor),
            checkmarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: checkmarkView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)])
    }
    
    func configCell() {
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    }
    
    private func setupStyles(_ selected: Bool) {
        if selected {
            contentView.backgroundColor = UIColor(hexCode: "#2196F3")
            checkmarkView.tintColor = UIColor(hexCode: "#E9EDF5")
            titleLabel.textColor = UIColor(hexCode: "#E9EDF5")
            titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        } else {
            contentView.backgroundColor = UIColor(hexCode: "#E9EDF5")?.withAlphaComponent(0.5)
            checkmarkView.tintColor = UIColor(hexCode: "#34353C")
            titleLabel.textColor = UIColor(hexCode: "#34353C")
            titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        }
    }
}
