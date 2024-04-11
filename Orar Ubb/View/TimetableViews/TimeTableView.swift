//
//  TimeTableView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 08.04.2024.
//

import SwiftUI

struct TimeTableView: View {
    @State var networkData = NetworkData(urlString: Links.I2)
    @FetchRequest(fetchRequest: SettingEntity.all())
    private var items: FetchedResults<SettingEntity>
    @State var alert: Bool = false
    private var item: SettingEntity? {
        if items.isEmpty {
            return nil
        } else {
            return items[0]
        }
    }
    @EnvironmentObject var sharedViewModel: SharedLecturesViewModel
    @FetchRequest(fetchRequest: Lecture.all())
    private var lectures: FetchedResults<Lecture>
    
    var body: some View {
        
        NavigationStack {
            WeekPicker(networkData: $networkData)
                TimeTableSchedule()
                    .navigationTitle("Schedule Babes-Bolyai University").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
//                        sharedViewModel.lectures = []
//                        let lecturesArray = Array(lectures)
//                        sharedViewModel.lectures = lecturesArray
                        CoreDataProvider.deleteAllData()
                        sharedViewModel.lectures = (networkData.fetchScheduel(html: item?.html ?? "No html", section: item?.section ?? "No section", group: item?.group ?? "No group", semiGroup: item?.semiGroup ?? "No semigroup"))
                    }) {
                        Image(systemName: "arrow.down.circle.dotted")
                            .font(.title)
                    }
                }
            }
        }
        .onAppear {
            sharedViewModel.lectures = Array(lectures)
        }
        
    }
}

#Preview {
    TimeTableView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedLecturesViewModel())
}
