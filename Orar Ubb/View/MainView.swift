//
//  MainView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 08.04.2024.
//

import SwiftUI

struct MainView: View {
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
        .tint(.red.opacity(0.7))
    }
}

#Preview {
    MainView()
}
