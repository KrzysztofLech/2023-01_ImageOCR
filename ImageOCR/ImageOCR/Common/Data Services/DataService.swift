//  DataService.swift
//  Created by Krzysztof Lech on 11/01/2023.

import CoreData

protocol DataServiceProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext()
    func fetch<T: NSManagedObject>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func delete(_ object: NSManagedObject)
}

final class DataService {
    private let coreDataModelName = "ImagesDataModel"
    private let persistentContainer: NSPersistentContainer

    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: coreDataModelName)

        // Use memory as a storage
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                print("Unable to initialize CoreData! Error: \(error.localizedDescription)")
            }
        }
    }
}

extension DataService: DataServiceProtocol {
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
            print("CoreDataService: Context saved!")
        } catch {
            print("Could not save! Error: \(error)")
        }
    }

    func fetch<T: NSManagedObject>(with predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(request)
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }

    func delete(_ object: NSManagedObject) {
        context.delete(object)

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
