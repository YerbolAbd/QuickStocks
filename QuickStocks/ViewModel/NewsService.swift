//
//  NewsService.swift
//  QuickStocks
//
//  Created by Ербол on 05.11.2024.
//

// NewsService.swift
import Foundation
import Alamofire

class NewsService {
    private let apiKey = "cskgv9hr01qn1f3vl270cskgv9hr01qn1f3vl27g"
    private let baseUrl = "https://finnhub.io/api/v1/news"
    
    func fetchMarketNews(completion: @escaping ([NewsItem]) -> Void) {
        let url = "\(baseUrl)?category=general&token=\(apiKey)"
        
        AF.request(url).response { response in
            guard let data = response.data else {
                print("Ошибка: нет данных от API")
                return
            }
            
            do {
                let decodedNews = try JSONDecoder().decode([NewsItem].self, from: data)
                completion(decodedNews)
            } catch {
                print("Ошибка декодирования данных: \(error)")
                completion([])
            }
        }
    }
}

