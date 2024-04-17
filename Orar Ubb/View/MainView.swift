//
//  MainView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 08.04.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var theTint: CourseColorPickersViewModel
    @EnvironmentObject var sharedViewModel: SharedTintColorViewModel
    var body: some View {
        TabView {
            TimeTableView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .onAppear {
            print("1  -> \(sharedViewModel.tintColor)")
            sharedViewModel.tintColor = theTint.getColorTint()
            print("2  -> \(sharedViewModel.tintColor)")
        }
        .tint(sharedViewModel.tintColor)
    }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedLecturesViewModel())
        .environmentObject(SharedGroupsViewModel())
        .environmentObject(CourseColorPickersViewModel())
        .environmentObject(SharedTintColorViewModel())
}
