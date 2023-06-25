//
//  CURDManager.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 24/06/23.
//

import CoreData
import UIKit

class CoreDataManager: NSObject {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - CRUD Operations
    
    func createEntity<T: NSManagedObject>() -> T? {
        guard let entityName = NSStringFromClass(T.self).components(separatedBy: ".").last else {
            return nil
        }
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as? T else {
            return nil
        }
        return entity
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func fetchEntities<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
            let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            
            do {
                return try managedObjectContext.fetch(fetchRequest)
            } catch {
                fatalError("Failed to fetch entities: \(error)")
            }
        }
    
    func deleteEntity(_ entity: NSManagedObject) {
        managedObjectContext.delete(entity)
    }
}
