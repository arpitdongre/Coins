//
//  ViewController.swift
//  Coins
//
//  Created by Arpit Dongre on 20/11/24.
//

import UIKit

class CoinListViewController: UIViewController {
    
    var viewModel: CoinListViewModel!
    private var tableView: UITableView!
    private var collectionView: UICollectionView!
    var offlineLabel: UILabel!
    
    var refreshControl: UIRefreshControl!
    private var loadingIndicator: UIActivityIndicatorView!
    
    // Error View
    private var errorMessageLabel: UILabel!
    private var retryButton: UIButton!
    
    private var loadingView: LoadingView!
    var errorView: ErrorView!
    
    private var filterItems: [FilterItem] = [
        FilterItem(title: "Active", filter: .active, isSelected: false),
        FilterItem(title: "New", filter: .new, isSelected: false),
        FilterItem(title: "Inactive", filter: .inactive, isSelected: false),
        FilterItem(title: "Only Coins", filter: .onlyCoins, isSelected: false),
        FilterItem(title: "Only Tokens", filter: .onlyTokens, isSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CoinListViewModel()
        
        view.backgroundColor = .white
        
        setupOfflineView()
        setupTableView()
        setupCollectionView()
        setupLoadingView()
        setupErrorView()
        setupRefreshControl()
        
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.updateOfflineLabelClosure = { [weak self] isConnected in
            self?.handleOfflineNetwork()
        }
        
        viewModel.showLoadingIndicatorClosure = {
            [weak self] in
            self?.loadingView.show()
        }
        
        viewModel.hideLoadingIndicatorClosure = {
            [weak self] in
            self?.loadingView.hide()
            self?.collectionView.isHidden = false
        }
        
        viewModel.showErrorViewClosure = {
            [weak self] in
            self?.errorView.showError(message: "An error occured. Please try again.")
        }
        
        viewModel.hideErrorViewClosure = {
            [weak self] in
            self?.errorView.isHidden = true
        }
        
        errorView.retryButtonTapped = {
            [weak self] in
            self?.refreshData()
        }
        
        Task {
            await viewModel.loadCoins()
        }
        
        self.navigationItem.title = "Coins"

        let lineImage = UIImage.fromColor(.gray)
        self.navigationController?.navigationBar.standardAppearance.shadowImage = lineImage
    }
    
    private func setupLoadingView() {
        loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)
    }
    
    private func setupErrorView() {
        errorView = ErrorView(frame: view.bounds)
        view.addSubview(errorView)
        errorView.isHidden = true
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupOfflineView() {
        offlineLabel = UILabel()
        
        offlineLabel.text = "You are offline. Please check your internet connection."
        offlineLabel.textColor = .white
        offlineLabel.translatesAutoresizingMaskIntoConstraints = false
        offlineLabel.numberOfLines = 2
        offlineLabel.font = UIFont.boldSystemFont(ofSize: 14)
        offlineLabel.textAlignment = .center
        
        let backgroundColor = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        offlineLabel.backgroundColor = backgroundColor
        
        self.view.addSubview(offlineLabel)
        
        NSLayoutConstraint.activate([
            offlineLabel.heightAnchor.constraint(equalToConstant: 0),
            offlineLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            offlineLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            offlineLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ]
        )
    }
    
    private func showErrorView() {
        errorView = ErrorView()
        view.addSubview(errorView)
    }
    
    func handleOfflineNetwork() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            NetworkManager.shared.isConnectedToInternet { isConnected in
                DispatchQueue.main.async {
                    self.animateOfflineLabel(isHidden: isConnected)
                }
            }
        }
    }
    
    func animateOfflineLabel(isHidden: Bool) {
        var height = 20
        
        if isHidden {
            self.offlineLabel.text = "Back online"
            self.offlineLabel.backgroundColor = .systemGreen
            height =  0
        } else {
            self.offlineLabel.text = "You are offline. Please check your internet connection."
            let backgroundColor = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
            self.offlineLabel.backgroundColor = backgroundColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //deactivate previous height constraints
            for constraint in self.offlineLabel.constraints where constraint.firstAttribute == .height {
                self.offlineLabel.removeConstraint(constraint)
            }
            
            UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
                
                NSLayoutConstraint.activate(
                    [
                        self.offlineLabel.heightAnchor.constraint(equalToConstant: CGFloat(height))
                    ]
                )
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setupTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CoinCell.self, forCellReuseIdentifier: "CoinCell")
        tableView.allowsSelection =  false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: self.offlineLabel.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ]
        )
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 45)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
        
        collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 60),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.isHidden = true
    }
    
    @objc func refreshData() {
        deselectAllFilters()
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                Task {
                    await self.viewModel.loadCoins()
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func deselectAllFilters() {
        filterItems = filterItems.map { filterItem in
            var filter = filterItem
            filter.isSelected = false
            return filter
        }
    }
    
    func applySelectedFilters() {
        var selectedFilters = [CoinFilter]()
        
        for item in filterItems where item.isSelected {
            selectedFilters.append(item.filter)
        }
        
        viewModel.applyFilters(selectedFilters)
        tableView.reloadData()
    }
}

extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = viewModel.coinAt(index: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinCell
        
        cell.cofigure(with: coin)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension CoinListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuseIdentifier, for: indexPath) as! FilterCollectionViewCell
        let filterItem = filterItems[indexPath.row]
        cell.filterItem = filterItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filterItems[indexPath.row].isSelected.toggle()
        
        applySelectedFilters()
        
        collectionView.reloadItems(at: [indexPath])
    }
}
