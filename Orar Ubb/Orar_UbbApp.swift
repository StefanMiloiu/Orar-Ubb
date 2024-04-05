//
//  Orar_UbbApp.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 05.04.2024.
//

import SwiftUI

@main
struct Orar_UbbApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
