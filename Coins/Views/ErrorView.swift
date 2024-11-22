//
//  ErrorView.swift
//  Coins
//
//  Created by Arpit Dongre on 22/11/24.
//

import UIKit

class ErrorView: UIView {

    private var errorMessageLabel: UILabel!
    private var retryButton: UIButton!
    
    var retryButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Error Message Label
        errorMessageLabel = UILabel()
        errorMessageLabel.textColor = .red
        errorMessageLabel.font = UIFont.systemFont(ofSize: 16)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.isHidden = true
        
        // Retry Button
        retryButton = UIButton(type: .system)
        retryButton.setTitle("Try Again", for: .normal)
        retryButton.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.isHidden = true
        
        addSubview(errorMessageLabel)
        addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            retryButton.centerXAnchor.constraint(equalTo: errorMessageLabel.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func showError(message: String) {
        isHidden = false
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
        retryButton.isHidden = false
    }
    
    func hideError() {
        isHidden = true
        errorMessageLabel.isHidden = true
        retryButton.isHidden = true
    }

    @objc private func retryAction() {
        retryButtonTapped?()
    }
}
