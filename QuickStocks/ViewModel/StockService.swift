//
//  StockService.swift
//  QuickStocks
//
//  Created by Ербол on 04.11.2024.
//

import Foundation
import Alamofire

class StockService {
    private let apiKey = "cskgv9hr01qn1f3vl270cskgv9hr01qn1f3vl27g"
    private let quoteBaseUrl = "https://finnhub.io/api/v1/quote"
    private let profileBaseUrl = "https://finnhub.io/api/v1/stock/profile2"
    private var cache: [String: Stock] = [:]
    private let operationQueue = OperationQueue()
    
    init() {
        operationQueue.maxConcurrentOperationCount = 5
    }
    
    func fetchStockQuotes(for symbols: [String], completion: @escaping ([Stock]) -> Void) {
        var stocks: [Stock] = []
        let dispatchGroup = DispatchGroup()
        
        for symbol in symbols {
            if let cachedStock = cache[symbol] {
                stocks.append(cachedStock)
                continue
            }
            
            dispatchGroup.enter()
            operationQueue.addOperation {
                let quoteUrl = "\(self.quoteBaseUrl)?symbol=\(symbol)&token=\(self.apiKey)"
                let profileUrl = "\(self.profileBaseUrl)?symbol=\(symbol)&token=\(self.apiKey)"
                
                
                AF.request(quoteUrl).responseJSON { quoteResponse in
                    guard let quoteData = quoteResponse.data else {
                        print("Ошибка: нет данных от API котировок для символа \(symbol)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    
                    AF.request(profileUrl).responseJSON { profileResponse in
                        guard let profileData = profileResponse.data else {
                            print("Ошибка: нет данных от API профиля для символа \(symbol)")
                            dispatchGroup.leave()
                            return
                        }
                        
                        do {
                            let decodedQuote = try JSONDecoder().decode(FinnhubStockResponse.self, from: quoteData)
                            let decodedProfile = try JSONDecoder().decode(FinnhubProfileResponse.self, from: profileData)
                            
                            let stock = Stock(
                                symbol: symbol,
                                name: decodedProfile.name,
                                price: decodedQuote.currentPrice,
                                change: decodedQuote.change
                            )
                            
                            self.cache[symbol] = stock
                            stocks.append(stock)
                        } catch {
                            print("Ошибка декодирования данных для символа \(symbol): \(error)")
                        }
                        
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(stocks)
        }
    }
}
