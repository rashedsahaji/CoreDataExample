//
//  HomeViewModel.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 24/06/23.
//

import Foundation
import CoreData

protocol HomeViewModelProtocol: AnyObject {
    func fetchPhotosList() async
    var photosList: Observable<Photos?> {get set}
    var itemPerPage: Int {get}
    var currentPage:Int {get set}
    var isLoading: Bool {get set}
    var allItemsLoaded: Observable<Bool> {get set}
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    var isLoading: Bool = false
    var allItemsLoaded: Observable<Bool> = Observable<Bool>(false)
    var currentPage: Int = 1
    var itemPerPage: Int = 10
    var photosList: Observable<Photos?> = Observable([])
    private let photoRestManager = PhotosRestManager()
    private let pictureDB = CoreDataManager(modelName: "picturescache")
    
    func fetchPhotosList() async {
        guard !isLoading && !allItemsLoaded.value else {
            return
        }
        isLoading = true
        do {
            guard let newItems = try await photoRestManager.getPhotosList(page: currentPage, limit: itemPerPage) else {return}
            saveToCoreData(newItems)
            photosList.value?.append(contentsOf: newItems)
            self.isLoading = false
            self.allItemsLoaded.value = newItems.count < self.itemPerPage
        } catch CustomErrors.noInternet {
            let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
            fetchRequest.fetchLimit = itemPerPage // Set the limit to 10 items per page
            fetchRequest.fetchOffset = (currentPage - 1) * itemPerPage // Calculate the offset based on the page number
            var fetchedEntities: [Entity] = []
            pictureDB.managedObjectContext.performAndWait {
                do {
                    fetchedEntities = try pictureDB.managedObjectContext.fetch(fetchRequest)
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }

            let cachedItemModels = fetchedEntities.map { entity in
                Photo(id: entity.id, author: entity.author, downloadURL: entity.downloadURL)
            }
            photosList.value?.append(contentsOf: cachedItemModels)
            self.isLoading = false
            self.allItemsLoaded.value = cachedItemModels.count < self.itemPerPage
        } catch {
            self.isLoading = false
            self.allItemsLoaded.value = false
            debugPrint("Unhanlded Exception \(error)")
        }
       
    }
    
    private func saveToCoreData(_ newItems: Photos) {
        pictureDB.managedObjectContext.performAndWait {
            newItems.forEach { item in
                let storeItem = Entity(context: pictureDB.managedObjectContext)
                storeItem.author = item.author ?? ""
                storeItem.downloadURL = item.downloadURL ?? ""
                storeItem.id = item.id ?? ""
            }
            pictureDB.saveContext()
        }
    }
    func deleteCachedItem() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Entity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try pictureDB.managedObjectContext.execute(deleteRequest)
        } catch {
            print("Error deleting all items from Core Data: \(error)")
        }
    }
}
