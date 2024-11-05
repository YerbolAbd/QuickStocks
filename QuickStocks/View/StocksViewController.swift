//
//  ViewController.swift
//  QuickStocks
//
//  Created by Ербол on 04.11.2024.
// StocksViewController.swift

import UIKit
import SnapKit
import Alamofire

class StocksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let stockService = StockService()
    private var stocks: [Stock] = []
    private var favoriteSymbols: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFavoriteSymbols()
        fetchStockQuotes()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        title = "Акции"
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor(white: 0.15, alpha: 1.0)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        
        tableView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "StockCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchStockQuotes() {
        let symbols = [
            "AAPL", "GOOG", "AMZN", "MSFT", "TSLA", "FB", "NFLX", "NVDA", "BABA", "INTC",
            "AMD", "IBM", "ORCL", "CSCO", "BA", "XOM", "CVX", "JNJ", "PFE", "WMT",
            "DIS", "KO", "MCD", "NKE", "V", "MA", "JPM", "GS", "C", "WFC"
        ]
        
        stockService.fetchStockQuotes(for: symbols) { [weak self] stocks in
            self?.stocks = stocks
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    private func loadFavoriteSymbols() {
        if let savedSymbols = UserDefaults.standard.array(forKey: "favoriteSymbols") as? [String] {
            favoriteSymbols = savedSymbols
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(favoriteSymbols, forKey: "favoriteSymbols")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        let stock = stocks[indexPath.row]
        cell.configure(with: stock)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToFavoritesAction = UIContextualAction(style: .normal, title: "Избранное") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let stock = self.stocks[indexPath.row]
            if !self.favoriteSymbols.contains(stock.symbol) {
                self.favoriteSymbols.append(stock.symbol)
            }
            completionHandler(true)
        }
        addToFavoritesAction.backgroundColor = .systemYellow
        
        return UISwipeActionsConfiguration(actions: [addToFavoritesAction])
    }
}
