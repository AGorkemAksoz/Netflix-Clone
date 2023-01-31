//
//  TV.swift
//  Netflix Clone
//
//  Created by Ali Görkem Aksöz on 31.01.2023.
//

import Foundation

struct TrendingTvResponse: Codable {
    let results: [Tv]
}
struct Tv: Codable {
    let id: Int?
    let media_types: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int?
    let release_date: String?
    let vote_average: Double?
}
