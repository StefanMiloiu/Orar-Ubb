//
//  Orar_UbbApp.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 05.04.2024.
//

import SwiftUI
import UIKit

@main
struct Orar_UbbApp: App {
    @StateObject var sharedViewModel = SharedGroupsViewModel()

var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
                .environmentObject(SharedTintColorViewModel())
                .environmentObject(sharedViewModel)
                .onAppear {
                    print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
                }
        }
    }
}
