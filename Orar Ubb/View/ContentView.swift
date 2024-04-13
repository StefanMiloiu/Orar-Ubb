//
//  ContentView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 05.04.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var sharedViewModel: SharedGroupsViewModel
    var body: some View {
        MainView()
            .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
            .environmentObject(sharedViewModel)
            .environmentObject(SharedLecturesViewModel())
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedGroupsViewModel()) // Ensure the result of environmentObject is used
        .environmentObject(SharedLecturesViewModel())
        .onAppear {
            print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        }
}
