///
/// CoreDataProvider class responsible for managing the Core Data stack.
///
/// - Author: Stefan Miloiu
/// - Date: 06.04.2024
///
import Foundation
import CoreData

class CoreDataProvider {
    
    static let shared = CoreDataProvider()
    let persistenceContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
    
    private init() {
        persistenceContainer = NSPersistentContainer(name: "Orar_Ubb")
        persistenceContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
//    static func deleteAllItems() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Lecture") // Replace "Lecture" with your entity name
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        print("deleted \(batchDeleteRequest) items")
//        do {
//            try CoreDataProvider.shared.viewContext.execute(batchDeleteRequest)
//        } catch {
//            print("Error deleting all items: \(error)")
//        }
//    }
    static func deleteAllItems(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Lecture") // Replace "Lecture" with your entity name
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        print("Deleting all items...")
        
        var deletedCount = 0
        do {
            let result = try CoreDataProvider.shared.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            if let deletedObjectIDs = result?.result as? [NSManagedObjectID] {
                deletedCount = deletedObjectIDs.count
            }
            print("Deleted \(deletedCount) items")
        } catch {
            print("Error deleting all items: \(error)")
        }
        
    }
    
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
}
