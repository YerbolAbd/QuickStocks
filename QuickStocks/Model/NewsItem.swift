//
//  NewsItem.swift
//  QuickStocks
//
//  Created by Ербол on 05.11.2024.
//

// News.swift
import Foundation

struct NewsItem: Decodable {
    let headline: String
    let summary: String
    let source: String
    let url: String
}

