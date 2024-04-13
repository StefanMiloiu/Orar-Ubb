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
    @State var selectedWeek = "1"
    var body: some View {
        
        NavigationStack {
            if sharedViewModel.lectures.isEmpty {
                VStack{
                    WeekPicker(selectedWeek: $selectedWeek, networkData: $networkData)
                        .padding(.horizontal, 10)
                        .navigationTitle("Schedule Babes-Bolyai University").navigationBarTitleDisplayMode(.inline)
                    Spacer()
                    Text("Please select all data (Groups/Semigroups) so we can fetch your schedule")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    Spacer()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    CoreDataProvider.deleteAllData()
                                    if item?.group != "" && item?.semiGroup != "" {
                                        sharedViewModel.lectures = (networkData.fetchScheduel(html: item?.html ?? "No html", section: item?.section ?? "No section", group: item?.group ?? "No group", semiGroup: item?.semiGroup ?? "No semigroup"))
                                    }
                                }) {
                                    Image(systemName: "arrow.down.circle.dotted")
                                        .font(.title)
                                }
                            }
                        }
                }
            } else {
                WeekPicker(selectedWeek: $selectedWeek, networkData: $networkData)
                    .padding(.horizontal, 10)
                TimeTableSchedule(selectedWeek: $selectedWeek)
                    .navigationTitle("Schedule Babes-Bolyai University").navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                CoreDataProvider.deleteAllData()
                                if item?.group != "" && item?.semiGroup != "" {
                                    sharedViewModel.lectures = (networkData.fetchScheduel(html: item?.html ?? "No html", section: item?.section ?? "No section", group: item?.group ?? "No group", semiGroup: item?.semiGroup ?? "No semigroup"))
                                }
                            }) {
                                Image(systemName: "arrow.down.circle.dotted")
                                    .font(.title)
                            }
                        }
                    }
            }
        }
        .onAppear {
            sharedViewModel.lectures = Array(lectures)
            //fetch again items
//            let items = FetchRequest(fetchRequest: SettingEntity.all()).wrappedValue
//            //assign the properties
//            if let itemul = items.first {
//                item?.section = itemul.section
//                item?.group = itemul.group
//                item?.semiGroup = itemul.semiGroup
//                item?.html = itemul.html
//            }
        }
        
    }
}

#Preview {
    TimeTableView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedLecturesViewModel())
}
