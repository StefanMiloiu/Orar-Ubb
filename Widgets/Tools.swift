//
//  Tools.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 16.04.2024.
//

import SwiftUI
import CoreData

struct WidgetTools {
    var dayDictionary =
    [
        "Luni": "Monday",
        "Marti": "Tuesday",
        "Miercuri": "Wednesday",
        "Joi": "Thursday",
        "Vineri": "Friday",
        "Sambata": "Saturday",
        "Duminica": "Sunday"
    ]
    
    func getWeekFromDate() -> String{
        let date = Date()
        let result = date.formatted(Date.FormatStyle().weekday(.wide)) // Thursday
        return result
        
    }
    
    func getWeekFromDateAbv() -> String{
        let date = Date()
        let result = date.formatted(Date.FormatStyle().weekday(.abbreviated)) // Thursday
        return result
        
    }
    
    func getCurrentHour() -> String {
        let date = Date() // Your Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let hourString = dateFormatter.string(from: date)
        //        let hour = Int(hourString) ?? 0 // Convert the hour string to an integer
        return hourString
    }
    
    func checkBetween(interval: String) -> Bool {
        var intervalArray = interval.components(separatedBy: "-")
        guard intervalArray.count == 2 else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        if intervalArray[0].count == 1 {
            intervalArray[0] = "0" + intervalArray[0]
        }
        let startHour = Int(intervalArray[0]) ?? 0
        let endHour = Int(intervalArray[1]) ?? 0
        
        let currentDate = Date()
        let currentHourString = dateFormatter.string(from: currentDate)
        let currentHour = Int(currentHourString) ?? 0
        
        // Calculate the start time with a 15-minute buffer
        let startHourWithBuffer = (startHour == 0 ? 23 : startHour - 1)
        let endHourWithBuffer = (endHour == 0 ? 23 : endHour - 1)
        
        // Check if the current hour falls within the adjusted interval
        if currentHour >= startHourWithBuffer && currentHour <= endHourWithBuffer {
            return true
        }
        return false
    }
    
    func checkNextLecture(interval: String) -> Bool {
        var intervalArray = interval.components(separatedBy: "-")
        guard intervalArray.count == 2 else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        if intervalArray[0].count == 1{
            intervalArray[0] = "0" + intervalArray[0]
        }
        
        let currentHourString = getCurrentHour()
        if currentHourString < intervalArray[0] {
            return true
        }
        return false
    }
    
    
    func checkRemainingLectures(interval: String) -> Bool {
        let intervalArray = interval.components(separatedBy: "-")
        guard intervalArray.count == 2 else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        let endHour = Int(intervalArray[1]) ?? 0
        
        let currentDate = Date()
        let currentHourString = dateFormatter.string(from: currentDate)
        let currentHour = Int(currentHourString) ?? 0
        
        // Calculate the start time with a 15-minute buffer
        let endHourWithBuffer = (endHour == 0 ? 23 : endHour - 1)
        
        // Check if the current hour falls within the adjusted interval
        if currentHour <= endHourWithBuffer {
            return true
        }
        return false
    }
    
    func getLecturesNotHidden(discipline: String) -> Bool{
        let context = CoreDataProvider.shared.viewContext
        let request = NSFetchRequest<DisciplineFilter>(entityName: "DisciplineFilter")
        
        do {
            let disciplines = try context.fetch(request)
            for disciplina in disciplines {
                if disciplina.checked == true && disciplina.discipline == discipline {
                    return false
                }
            }
            return true
        } catch {
            print("Error fetching lectures")
        }
        return true
    }
    
}
