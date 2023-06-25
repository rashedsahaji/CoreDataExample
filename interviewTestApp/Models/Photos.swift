//
//  Photos.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 24/06/23.
//
//   let photos = try? JSONDecoder().decode(Photos.self, from: jsonData)

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id, author: String?
    let downloadURL: String?

    enum CodingKeys: String, CodingKey {
        case id, author
        case downloadURL = "download_url"
    }
}

typealias Photos = [Photo]
