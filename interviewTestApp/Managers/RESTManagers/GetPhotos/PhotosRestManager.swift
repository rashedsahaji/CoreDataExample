//
//  PhotosRestManager.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 24/06/23.
//

import Foundation
import CoreData

actor PhotosRestManager {
    private let pictureDB = CoreDataManager(modelName: "picturescache")
    //MARK: - For Getting Photos List with pagination
    public func getPhotosList(page: Int, limit: Int) async throws -> Photos? {
        do {
            let response = try await APIManager.shared.getData(from: PhotosEndPoint.getListOfPhotos(page: page, limit: limit))
            if (response.statusCode == 200) {
                let result = try JSONDecoder().decode(Photos.self, from: response.data)
                return result
            }
        } catch {
            throw CustomErrors.noInternet
        }
        return nil
    }
}
