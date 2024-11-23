//
//  CoinCell.swift
//  Coins
//
//  Created by Arpit Dongre on 20/11/24.
//

import UIKit

class CoinCell: UITableViewCell {
    
    private var nameLabel: UILabel!
    private var symbolLabel: UILabel!
    private var coinImageView: UIImageView!
    private var newImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel()
        symbolLabel = UILabel()
        coinImageView = UIImageView()
        newImageView = UIImageView()
        
        symbolLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coinImageView)
        
        newImageView.contentMode = .scaleAspectFit
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newImageView)

        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            coinImageView.widthAnchor.constraint(equalToConstant: 32),
            coinImageView.heightAnchor.constraint(equalToConstant: 32),
            coinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            coinImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            newImageView.widthAnchor.constraint(equalToConstant: 22),
            newImageView.heightAnchor.constraint(equalToConstant: 22),
            newImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            newImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with coin: Coin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        coinImageView.image = UIImage(named: coin.imageName)
        newImageView.image = UIImage(named: "new-coin")
        
        if coin.isNew {
            newImageView.isHidden = false
        } else {
            newImageView.isHidden = true
        }
    }
}
