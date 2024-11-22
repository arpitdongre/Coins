//
//  FilterCollectionViewCell.swift
//  Coins
//
//  Created by Arpit Dongre on 20/11/24.
//

import UIKit

struct FilterItem {
    let title: String
    let filter: CoinFilter
    var isSelected: Bool
}

class FilterCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FilterCell"
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var filterItem: FilterItem? {
        didSet {
            filterLabel.text = filterItem?.title
            updateAppearance()
        }
    }
    
    private func updateAppearance() {
        if filterItem?.isSelected == true {
            
            let lightBlue = UIColor(red: 0, green: 153/255.0, blue: 1, alpha: 1.0)
            self.contentView.backgroundColor = lightBlue
            filterLabel.textColor = .white
        } else {
            self.contentView.backgroundColor = .white
            filterLabel.textColor = .black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.contentView.addSubview(filterLabel)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}
