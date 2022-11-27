//
//  MovieController.swift
//  Movie
//
//  Created by new on 7/1/22.
//

import Foundation
import UIKit

class MovieController {
    //https://api.themoviedb.org/3/search/movie?api_key=1b617daef0238a132b45ac764be15582&query=spider
    
    static let baseURL = URL(string: "https://api.themoviedb.org")
    static let searchMovieComponent = "3/search/movie"
    static let apiKey = "api_key"
    static let apiKeyValue = "1b617daef0238a132b45ac764be15582"
    static let searchtermKey = "query"
    static let movieURLBase = ""
    
    static func fetchMovieInfo(with searchterm: String, completion: @escaping (Result<[MovieInfo], MovieError>) -> Void ) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        let movieSearchURL = baseURL.appendingPathComponent(searchMovieComponent)
        
        var components = URLComponents(url: movieSearchURL, resolvingAgainstBaseURL: true)
        
        let accessQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        
        let searchTermQuery = URLQueryItem(name: searchtermKey, value: searchterm)
        
        components?.queryItems = [accessQuery, searchTermQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let topLevelObj = try JSONDecoder().decode(TopLevelObj.self, from: data)
                let results = topLevelObj.results
                completion(.success(results))
            } catch {
                print("Error")
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchURL(poster: MovieInfo, completion: @escaping (Result<UIImage, MovieError>) -> Void) {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
        guard let poster = poster.url else { return }
        guard let newurl = baseURL?.appendingPathComponent(poster) else {
            return completion(.failure(.invalidURL))
        }
        //print("***********************\(newurl)")
        URLSession.shared.dataTask(with: newurl) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                return completion(.failure(.noData))
            }
            guard let url = UIImage(data: data) else {
                return completion(.failure(.noMovieImage))
            }
            return completion(.success(url))
        }.resume()
    }
}


