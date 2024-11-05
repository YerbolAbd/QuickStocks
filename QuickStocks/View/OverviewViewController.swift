//
//  OverviewViewController.swift
//  QuickStocks
//
//  Created by Ербол on 04.11.2024.
//

// OverviewViewController.swift
import UIKit
import Alamofire

class OverviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let tableView = UITableView()
    private var news: [NewsItem] = [] 
    private let newsService = NewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMarketNews()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        
        
        titleLabel.text = "Обзор рынка"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        dateLabel.text = "за \(dateFormatter.string(from: Date()).capitalized)"
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .lightGray
        view.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
        }
        
        
        tableView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func fetchMarketNews() {
        newsService.fetchMarketNews { [weak self] fetchedNews in
            self?.news = fetchedNews
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let newsItem = news[indexPath.row]
        cell.configure(with: newsItem)
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = news[indexPath.row]
        let webViewController = WebViewController()
        webViewController.urlString = newsItem.url
        present(webViewController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


