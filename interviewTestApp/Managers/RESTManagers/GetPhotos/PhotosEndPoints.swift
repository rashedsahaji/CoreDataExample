//
//  PhotosEndPoints.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 24/06/23.
//

import Foundation
private struct PhotosConstants {
    static let list = "/v2/list";
}

enum PhotosEndPoint {
    case getListOfPhotos(page: Int, limit: Int)
}

extension PhotosEndPoint : EndPoint {
    var path: String {
        switch self {
        case .getListOfPhotos:
            return PhotosConstants.list
        }
    }
    
    var baseURL: String {
        KeysManager.URLs.apiBaseURL.value
    }
    
    var url: URL? {
        URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .getListOfPhotos:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getListOfPhotos:
            return ["Content-Type": "application/json"]
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .getListOfPhotos(let page, let limit):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "limit", value: "\(limit)")]
        }
    }
    
    
}
