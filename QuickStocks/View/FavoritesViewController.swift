//
//  FavoritesViewController.swift
//  QuickStocks
//
//  Created by Ербол on 05.11.2024.
//
// FavoritesViewController.swift


import UIKit
import SnapKit
import Alamofire

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let stockService = StockService()
    private var favoriteSymbols: [String] = []
    private var favoriteStocks: [Stock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteSymbols()
        fetchFavoriteStockQuotes()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        title = "Избранное"
        
        titleLabel.text = "Избранное"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        tableView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "FavoriteStockCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadFavoriteSymbols() {
        if let savedSymbols = UserDefaults.standard.array(forKey: "favoriteSymbols") as? [String] {
            favoriteSymbols = savedSymbols
        }
    }
    
    private func fetchFavoriteStockQuotes() {
        let batchSize = 5
        var index = 0
        
        favoriteStocks.removeAll()
        
        
        while index < favoriteSymbols.count {
            let batch = Array(favoriteSymbols[index..<min(index + batchSize, favoriteSymbols.count)])
            index += batchSize
            
            stockService.fetchStockQuotes(for: batch) { [weak self] stocks in
                self?.favoriteStocks.append(contentsOf: stocks)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteStockCell", for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        let stock = favoriteStocks[indexPath.row]
        cell.configure(with: stock)
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let stock = self.favoriteStocks[indexPath.row]
            
            
            if let symbolIndex = self.favoriteSymbols.firstIndex(of: stock.symbol) {
                self.favoriteSymbols.remove(at: symbolIndex)
                UserDefaults.standard.set(self.favoriteSymbols, forKey: "favoriteSymbols")
            }
            
            
            self.favoriteStocks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
