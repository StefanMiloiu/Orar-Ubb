///
/// CoreDataProvider class responsible for managing the Core Data stack.
///
/// - Author: Stefan Miloiu
/// - Date: 06.04.2024
///
import Foundation
import CoreData

//MARK: - CoreDataProvider
class CoreDataProvider {
    
    //MARK: - Properties
    // Singleton instance of the CoreDataProvider.
    static let shared = CoreDataProvider()
    let persistenceContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
    
    //MARK: - Initializer
    // Private initializer to prevent multiple instances of CoreDataProvider.
    private init() {
        persistenceContainer = NSPersistentContainer(name: "Orar_Ubb")
        let url = URL.storeURl(for: "group.com.miloiu.Orar-Ubb", databaseName: "Orar_Ubb")
        let storeDescriptor = NSPersistentStoreDescription(url: url)
        persistenceContainer.persistentStoreDescriptions = [storeDescriptor]
        
        persistenceContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        persistenceContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //MARK: - Methods
    // Delete then save the context.
    static func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lecture")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataProvider.shared.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                CoreDataProvider.shared.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in Lecture error :", error)
        }
    }
    
    // Delete then save the context.
    static func deleteAllDataFilter() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DisciplineFilter")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataProvider.shared.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                CoreDataProvider.shared.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in DisciplineFilter error :", error)
        }
    }
    
    
}

//MARK: - URL Extension
// Extension to create a URL for the shared file container. (Capabilities -> App Groups (used for widgets))
public extension URL {
    static func storeURl(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
