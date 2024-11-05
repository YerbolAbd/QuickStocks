//
//  NewsTableViewCell.swift
//  QuickStocks
//
//  Created by Ербол on 04.11.2024.
//

// NewsTableViewCell.swift
import UIKit

class NewsTableViewCell: UITableViewCell {
    private let headlineLabel = UILabel()
    private let summaryLabel = UILabel()
    private let sourceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(white: 0.15, alpha: 1.0)

        headlineLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headlineLabel.textColor = .white
        contentView.addSubview(headlineLabel)

        summaryLabel.font = UIFont.systemFont(ofSize: 14)
        summaryLabel.textColor = .lightGray
        summaryLabel.numberOfLines = 2
        contentView.addSubview(summaryLabel)

        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textColor = .gray
        contentView.addSubview(sourceLabel)

        headlineLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }

        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(headlineLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(4)
            make.leading.bottom.trailing.equalToSuperview().inset(10)
        }
    }

    func configure(with newsItem: NewsItem) {
        headlineLabel.text = newsItem.headline
        summaryLabel.text = newsItem.summary
        sourceLabel.text = newsItem.source
    }
}
