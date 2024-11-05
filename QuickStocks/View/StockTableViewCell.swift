//
//  StockTableViewCell.swift
//  QuickStocks
//
//  Created by Ербол on 04.11.2024.
//

import UIKit
import SnapKit

class StockTableViewCell: UITableViewCell {
    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    private let chartView = StockChartView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    
    
    private let priceContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        
        
        symbolLabel.font = UIFont.boldSystemFont(ofSize: 14)
        symbolLabel.textColor = .white
        
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
        nameLabel.numberOfLines = 1
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceLabel.textColor = .white
        priceLabel.textAlignment = .right
        
        changeLabel.font = UIFont.systemFont(ofSize: 14)
        changeLabel.textAlignment = .center
        changeLabel.layer.cornerRadius = 10
        changeLabel.layer.masksToBounds = true
        changeLabel.textColor = .white
        
        
        contentView.addSubview(symbolLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceContainerView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeLabel)
        contentView.addSubview(chartView)
        
        
        symbolLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(symbolLabel)
            make.top.equalTo(symbolLabel.snp.bottom).offset(2)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        
        priceContainerView.snp.makeConstraints { make in
            make.trailing.equalTo(changeLabel.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(priceContainerView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        chartView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(priceContainerView.snp.leading).offset(-5)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    func configure(with stock: Stock) {
        symbolLabel.text = stock.symbol
        
        
        if stock.name.count > 20 {
            let truncatedName = String(stock.name.prefix(20)) + "..."
            nameLabel.text = truncatedName
        } else {
            nameLabel.text = stock.name
        }
        
        
        if let price = stock.price {
            priceLabel.text = String(format: "%.2f", price)
        } else {
            priceLabel.text = "N/A"
        }
        
        if let change = stock.change {
            changeLabel.text = String(format: "%.2f", change)
            let softRed = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.8)
            let softGreen = UIColor(red: 0.3, green: 1.0, blue: 0.3, alpha: 0.8)
            
            if change >= 0 {
                changeLabel.backgroundColor = softGreen
                chartView.drawRandomGraph(isRising: true)
            } else {
                changeLabel.backgroundColor = softRed
                chartView.drawRandomGraph(isRising: false)
            }
        } else {
            changeLabel.text = "N/A"
            changeLabel.backgroundColor = UIColor.gray
        }
    }
}
