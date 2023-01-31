//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Ali Görkem Aksöz on 31.01.2023.
//https://api.themoviedb.org/3/movie/upcoming?api_key=1f4cd44a27f52e7c527fa1a39efc8c2d&language=en-US&page=1

import Foundation

struct Constants {
    static let API_KEY = "1f4cd44a27f52e7c527fa1a39efc8c2d"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    private init() { }
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch  {
                completion(.failure(.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTrendingTVs(completion: @escaping (Result<[Tv], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
                print(results)
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                print(result)
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                print(result)
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                print(result)
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

//https://api.themoviedb.org/3/movie/top_rated?api_key=1f4cd44a27f52e7c527fa1a39efc8c2d&language=en-US&page=1
