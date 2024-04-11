//
//  CoreDataModel.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 08.04.2024.
//

import Foundation
import CoreData

//MARK: - Model protocol
protocol Model {
    
}

//MARK: - Model extension
extension Model where Self: NSManagedObject {
    
    //Save
    func save() throws{
        try CoreDataProvider.shared.viewContext.save()
    }
    
    //Delete
    func delete() throws {
        CoreDataProvider.shared.viewContext.delete(self)
        try CoreDataProvider.shared.viewContext.save()
    }
    
    //Find all
//    static func all() -> NSFetchRequest<Self> {
//        let request = NSFetchRequest<Self>(entityName: String(describing: self))
//        request.sortDescriptors = []
//        return request
//    }
    static func all() -> NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: String(describing: self))
        request.sortDescriptors = []
        
        // Add a predicate to filter out deleted items
//        request.predicate = NSPredicate(format: "isDeleted == %@", NSNumber(value: false))
        return request
    }
    
    
//    //Find first
//    static func first() -> Self {
//        let request = all()
//        request.fetchLimit = 1
//        do {
//            let item = try CoreDataProvider.shared.viewContext.fetch(request).first!
//            return item
//        }catch {
//            print(error)
//        }
//        return Self.init()
//    }
    
}
