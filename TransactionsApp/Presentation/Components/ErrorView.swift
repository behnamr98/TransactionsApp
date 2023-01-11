//
//  ServerErrorView.swift
//  TransactionsApp
//
//  Created by Behnam on 12/26/22.
//

import UIKit

class ErrorView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: "#34353C")
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: "#949BAA")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "no-connection")
        return imageView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(hexCode: "#34353C")?.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexCode: "#949BAA")?.withAlphaComponent(0.5).cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    var model: ErrorMessageStyle? {
        didSet { setupValues() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
        addViews()
        setupConstraints()
        setupValues()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
    }
    
    func addViews() {
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(imageView)
        addSubview(button)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descLabel.heightAnchor.constraint(equalToConstant: 70),
            descLabel.widthAnchor.constraint(equalToConstant: 320),
            
            imageView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            button.widthAnchor.constraint(equalToConstant: 128),
            button.heightAnchor.constraint(equalToConstant: 36),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)])
    }
    
    private func setupValues() {
        guard let model = model else { return }
        titleLabel.text = model.title
        descLabel.text = model.description
        imageView.image = UIImage(named: model.image)
        button.isHidden = !model.haveButton
        button.setTitle(model.buttonTitle, for: .normal)
    }
}

protocol ErrorMessageStyle {
    var title: String { get }
    var description: String { get }
    var image: String { get }
    var haveButton: Bool { get }
    var buttonTitle: String { get }
}

struct ErrorMessageStyles {
    
    struct NoConnectionStyle: ErrorMessageStyle {
        var title: String = "No internet"
        var description: String = "Please check your internet connection"
        var image: String = "no-connection"
        var haveButton: Bool = false
        var buttonTitle: String = ""
    }
    
    struct ServerErrorStyle: ErrorMessageStyle {
        var title: String = "Opps!"
        var description: String = "Something went wrong, We are not sure yet and will examine this case. Try to relaunch the app."
        var image: String = "no-connection"
        var haveButton: Bool = true
        var buttonTitle: String = "Try again"
    }
}
