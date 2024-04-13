//
//  WeekPicker.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 10.04.2024.
//

import SwiftUI

struct WeekPicker: View {
    @Binding var selectedWeek: String
    @Binding var networkData: NetworkData
    
    @EnvironmentObject var sharedViewModel: SharedLecturesViewModel
    @FetchRequest(fetchRequest: SettingEntity.all())
    private var settings: FetchedResults<SettingEntity>
    var item: SettingEntity? {
        if settings.isEmpty {
            return nil
        } else {
            return settings[0]
        }
    }
    @FetchRequest(fetchRequest: Lecture.all())
    private var lectures: FetchedResults<Lecture>
    var body: some View {
        Picker("Weeks", selection: $selectedWeek) {
            ForEach(1..<3) { week in
                Text("Week \(week)")
                    .tag("sapt. \(week)")
            }
            Text("All weeks")
                .tag(" ")
        }
        .onChange(of: selectedWeek) {
            if selectedWeek != " " {
                sharedViewModel.lectures = networkData.fetchScheduel(html: item?.html ?? "No html", section: item?.section ?? "No section", group: item?.group ?? "No group", semiGroup: item?.semiGroup ?? "No semigroup").filter {$0.parity == " " || $0.parity == selectedWeek}
            } else {
                sharedViewModel.lectures = networkData.fetchScheduel(html: item?.html ?? "No html", section: item?.section ?? "No section", group: item?.group ?? "No group", semiGroup: item?.semiGroup ?? "No semigroup")
            }
//            print("Selected week: \(selectedWeek)")
        }
        .pickerStyle(.segmented)
        .onAppear {
            selectedWeek = " "
        }
    }
}

#Preview {
    WeekPicker(selectedWeek: .constant("1"),networkData: .constant(NetworkData(urlString: Links.I2)))
        .environmentObject(SharedLecturesViewModel())
}
