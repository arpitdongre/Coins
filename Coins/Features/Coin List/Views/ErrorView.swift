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
    private var loadingOverlay: UIView!
    
    var retryButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoadingOverlay()
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoadingOverlay()
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
    
    private func setupLoadingOverlay() {
        loadingOverlay = UIView(frame: bounds)
        loadingOverlay.backgroundColor = UIColor.white
        addSubview(loadingOverlay)
        
        NSLayoutConstraint.activate([
            loadingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingOverlay.topAnchor.constraint(equalTo: topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        loadingOverlay.isHidden = true
    }
    
    func showError(message: String) {
        isHidden = false
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
        retryButton.isHidden = false
        loadingOverlay.isHidden = false
    }
    
    func hideError() {
        isHidden = true
        errorMessageLabel.isHidden = true
        retryButton.isHidden = true
        loadingOverlay.isHidden = true
        self.layoutIfNeeded()
    }

    @objc private func retryAction() {
        retryButtonTapped?()
    }
}
