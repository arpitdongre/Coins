//
//  LoadingView.swift
//  Coins
//
//  Created by Arpit Dongre on 22/11/24.
//

import UIKit

class LoadingView: UIView {

    private var loadingIndicator: UIActivityIndicatorView!
    private var loadingOverlay: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoadingIndicator()
        setupLoadingOverlay()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoadingIndicator()
        setupLoadingOverlay()
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.color = .black
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func setupLoadingOverlay() {
        loadingOverlay = UIView(frame: bounds)
        loadingOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(loadingOverlay)
        
        NSLayoutConstraint.activate([
            loadingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingOverlay.topAnchor.constraint(equalTo: topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        loadingOverlay.isHidden = true
    }

    func show() {
        isHidden = false
        loadingOverlay.isHidden = false
        loadingIndicator.startAnimating()
    }

    func hide() {
        isHidden = true
        loadingOverlay.isHidden = true
        loadingIndicator.stopAnimating()
    }
}
