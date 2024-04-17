//
//  TimeTableView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 08.04.2024.
//

import SwiftUI
import WidgetKit

struct TimeTableView: View {
    @State var networkData = NetworkData(urlString: Links.I2)
    @FetchRequest(fetchRequest: SettingEntity.all())
    private var items: FetchedResults<SettingEntity>
    @State var alert: Bool = false
    @State var isShowingSheet = false
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
    @FetchRequest(fetchRequest: DisciplineFilter.all())
    var disciplines: FetchedResults<DisciplineFilter>
    @Environment(\.verticalSizeClass) var sizeClass
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
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                CoreDataProvider.deleteAllData()
                                if item?.group != "" && item?.semiGroup != "" {
                                    selectedWeek = " "
                                    sharedViewModel.lectures = (networkData.fetchScheduel(html: item?.html ?? "No html", section: item?.section ?? "No section", group: item?.group ?? "No group", semiGroup: item?.semiGroup ?? "No semigroup"))
                                    sharedViewModel.disciplines = networkData.fetchDisciplinesFilter(lectures: sharedViewModel.lectures)
                                    WidgetCenter.shared.reloadAllTimelines()
                                }
                            }) {
                                Image(systemName: "arrow.down.circle.dotted")
                                    .font(.title)
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                isShowingSheet.toggle()
                            }) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .font(.title)
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingSheet, content: {
                        NavigationStack{
                            FiltersView()
                        }
                        .presentationCompactAdaptation(.sheet)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.medium, .large])
                        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
                    })
            }
        }
        .onAppear {
            sharedViewModel.disciplines = Array(disciplines)
            sharedViewModel.lectures = Array(lectures).filter { lecture in
                let checkedDisciplines = sharedViewModel.disciplines.filter { $0.checked }.map { $0.discipline }
                
                // Check if lecture's discipline is in checked disciplines
                let isDisciplineChecked = !checkedDisciplines.contains(lecture.discipline)
                return isDisciplineChecked
            }
        }
        
    }
}

#Preview {
    TimeTableView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedLecturesViewModel())
}
