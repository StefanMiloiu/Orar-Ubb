//
//  NetworkData.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 05.04.2024.
//

import Foundation
import SwiftSoup
import CoreData
//Get the html from a website

class NetworkData: ObservableObject {
    static let shared = NetworkData(urlString: Links.I2)
    
    var urlString: String
    static var html: String = ""
    var section: String = ""
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    
    func getHTML(url: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let htmlString = String(data: data, encoding: .utf8) {
                NetworkData.html = htmlString
                completion(htmlString)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func getYear() -> Int {
        do {
            let doc: Document = try SwiftSoup.parse(NetworkData.html)
            let year: String = try doc.title().components(separatedBy: " ")[1]
            print(year)
        } catch Exception.Error(let type, let message) {
            print(String(describing: type) + ": " + message)
        } catch {
            print("error")
        }
        return 0
    }
    
    func extractLecturesFromHTML() {
        do {
            let doc: Document = try SwiftSoup.parse(NetworkData.html)
            let rows = try doc.select("tr") // Select all table rows
            for row in rows {
                let cells = try row.select("td") // Select all cells in the row
                if cells.count >= 7 {
                    let day = try cells[0].text()
                    let time = try cells[1].text()
                    let room = try cells[3].text()
                    let group = try cells[4].text()
                    let type = try cells[5].text()
                    let subject = try cells[6].select("a").text()
                    let lecturer = try cells[7].select("a").text()
                    print(day, time, room, group, type, subject, lecturer)
                }
            }
        } catch Exception.Error(let type, let message) {
            print(String(describing: type) + ": " + message)
        } catch {
            print("Error parsing HTML content")
        }
    }
    
    func fetchGroupsForSection(html: String) -> [String]{
        var grupe = [String]()
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let groups = try doc.getElementsByTag("h1")
            
            for group in groups {
                grupe.append(try group.text())
            }
            if !grupe.isEmpty{
                grupe.remove(at: 0)
            }
        } catch Exception.Error(let type, let message) {
            print(String(describing: type) + ": " + message)
        } catch {
            print("Error parsing HTML content")
        }
        return grupe
    }
    
    func fetchScheduel(html: String, section: String, group: String, semiGroup: String) -> [Lecture] {
        var lectures: [Lecture] = []
        CoreDataProvider.deleteAllData()
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let tables = try doc.select("table")
            var counter = 0
            for table in tables {
                counter += 1
                if Int(group)! % 10 == counter {
                    let rows = try table.select("tr")
                    for row in rows {
                        let cells = try row.select("td")
                        
                        if cells.count >= 7 {
                            
                            let day = try cells[0].text()
                            let time = try cells[1].text()
                            var parity = try cells[2].text()
                            if parity != "sapt. 1" && parity != "sapt. 2"{
                                parity = " "
                            }
                            let room = try cells[3].text()
                            let format = try cells[4].text()
                            let type = try cells[5].text()
                            let subject = try cells[6].select("a").text()
                            let lecturer = try cells[7].select("a").text()
                            if format == "\(group)/\(semiGroup)" || format == Links.getNameFromLink(link: section) || format == group{
                                let newLecture = Lecture(context: CoreDataProvider.shared.viewContext)
                                newLecture.day = day
                                newLecture.time = time
                                newLecture.room = room
                                newLecture.parity = parity
                                newLecture.type = type
                                newLecture.discipline = subject
                                newLecture.professor = lecturer
                                do {
                                    lectures.append(newLecture)
                                    try CoreDataProvider.shared.viewContext.save()
                                } catch {
                                    print("Error saving context")
                                }
                            }
                        }
                    }
                }
            }
        } catch Exception.Error(let type, let message) {
            print(String(describing: type) + ": " + message)
        } catch {
            print("Error parsing HTML content")
        }
        return lectures
    }
    
}
