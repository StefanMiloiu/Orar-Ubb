//
//  ColorFilterViewModel.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 15.04.2024.
//

import Foundation
import SwiftUI
import CoreData

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {

    var components: (r: Double, g: Double, b: Double, a: Double) {
        
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return (0,0,0,0) }
        
        return (Double(r), Double(g), Double(b), Double(a))
    }
}

class CourseColorPickersViewModel: ObservableObject {
    var coreDataHandler = CoreDataProvider.shared
    
    func updateColor(courseType: String, color: Color) {
        let colorComponents = color.components
        let r = colorComponents.r
        let g = colorComponents.g
        let b = colorComponents.b
        let a = colorComponents.a
        
        let fetchRequest = NSFetchRequest<ColorFilter>(entityName: "ColorFilter")
        fetchRequest.predicate = NSPredicate(format: "courseType == %@", courseType)
        
        do {
            let color = try coreDataHandler.viewContext.fetch(fetchRequest)
            if let color = color.first {
                color.r = r
                color.g = g
                color.b = b
                color.a = a
            } else {
                addColor(courseType: courseType, r: r, g: g, b: b, a: a)
            }
            
            try coreDataHandler.viewContext.save()
        } catch let error {
            print("Error updating color: \(error)")
        }
    }
    
    private func addColor(courseType: String, r: Double, g: Double, b: Double, a: Double) {
        let newColor = ColorFilter(context: coreDataHandler.viewContext)
        newColor.courseType = courseType
        newColor.r = r
        newColor.g = g
        newColor.b = b
        newColor.a = a
        
        do{
            try coreDataHandler.viewContext.save()
        } catch let error {
            print("Error saving new color: \(error)")
        }
    }
    
    func getColor(courseType: String) -> Color {
        let fetchRequest = NSFetchRequest<ColorFilter>(entityName: "ColorFilter")
        fetchRequest.predicate = NSPredicate(format: "courseType == %@", courseType)
        
        do {
            let color = try coreDataHandler.viewContext.fetch(fetchRequest)
            if let color = color.first {
                return Color(red: color.r, green: color.g, blue: color.b, opacity: color.a)
            }
        } catch let error {
            print("Error getting color: \(error)")
        }
        
        return Color.gray
    }
    
    func getColorTint() -> Color {
        let fetchRequest = NSFetchRequest<ColorFilter>(entityName: "ColorFilter")
        fetchRequest.predicate = NSPredicate(format: "courseType == %@", "Tint")
        
        do {
            let color = try coreDataHandler.viewContext.fetch(fetchRequest)
            if let color = color.first {
                print("GETCOLORTINT -> \(color)")
                return Color(red: color.r, green: color.g, blue: color.b, opacity: color.a)
            }
        } catch let error {
            print("Error getting color: \(error)")
        }
        
        return Color.red.opacity(0.7)
    }
    
    func removeAllColors() {
        let fetchRequest = NSFetchRequest<ColorFilter>(entityName: "ColorFilter")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try coreDataHandler.viewContext.execute(deleteRequest)
        } catch let error {
            print("Error deleting all colors: \(error)")
        }
    }
}
