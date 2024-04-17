//
//  ContentView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 05.04.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var sharedViewModel: SharedTintColorViewModel
    @EnvironmentObject var theTint: CourseColorPickersViewModel
    var body: some View {
        MainView()
            .tint(sharedViewModel.tintColor)
            .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
            .environmentObject(SharedGroupsViewModel())
            .environmentObject(SharedLecturesViewModel())
            .environmentObject(CourseColorPickersViewModel())
            .environmentObject(SharedTintColorViewModel())
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedGroupsViewModel()) // Ensure the result of environmentObject is used
        .environmentObject(CourseColorPickersViewModel())
        .environmentObject(SharedLecturesViewModel())
        .environmentObject(SharedTintColorViewModel())
        .onAppear {
            print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        }
}
