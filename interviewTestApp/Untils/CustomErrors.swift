//
//  CustomErrors.swift
//  moviedb
//
//  Created by Rashed Sahajee on 24/06/23.
//

import Foundation

enum CustomErrors: Error  {
    case invalidResponse
    case invalidURL
    case invalidData
    case noInternet
    case network(Error?)
}

extension CustomErrors: LocalizedError {
    public var errorDescription: String? {
        return nil
    }
}
