//
//  MovieError.swift
//  Movie
//
//  Created by new on 7/1/22.
//

import Foundation

enum MovieError: LocalizedError {
    case invalidURL
    case serverError(Error)
    case noData
    case thrownError(Error)
    case noMovieImage
    
    var errorDescription: String? {
        switch self {
            
        case .invalidURL:
            return "the call URL is invalid"
        case .serverError(let error):
            return "The server has returned an error : \(error.localizedDescription)"
        case .noData:
            return "The server has returned no data"
        case .thrownError(let error):
            return "Thrown error while decoding JSON from the server : \(error.localizedDescription)"
        case .noMovieImage:
            return "Could not create UImage from data"
        }
    }
}
