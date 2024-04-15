//
//  SettingsSemigroupsView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 08.04.2024.
//

import SwiftUI
import WidgetKit

struct SettingsSemigroupsView: View {
    @EnvironmentObject var sharedViewModel: SharedGroupsViewModel
    @EnvironmentObject var sharedViewModelLectures: SharedLecturesViewModel
    @FetchRequest(fetchRequest: SettingEntity.all())
    private var items: FetchedResults<SettingEntity>
    @Binding var networkData: NetworkData
    @State var selectedSemigroup = ""
    @State var semiGroup = ["1", "2"]
    @State var alert = false
    
    var item: SettingEntity? {
        if items.isEmpty {
            return nil
        } else {
            return items[0]
        }
    }
    
    func save() {
        do{
            if let item = item, item.section != nil{
                item.semiGroup = sharedViewModel.selectedSemiGroup
                try CoreDataProvider.shared.viewContext.save()
            } else {
                alert.toggle()
            }
        }catch let error {
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        Picker("Semigroup", selection: Binding<String>(
            get: {sharedViewModel.selectedSemiGroup},
            set: {newValue in
                sharedViewModel.selectedSemiGroup = newValue
            }
        )) {
            ForEach(semiGroup, id: \.self) { semigroup in
                Text(semigroup)
                    .tag(semigroup)
            }
            .onChange(of: sharedViewModel.selectedSemiGroup) {
                CoreDataProvider.deleteAllData()
                save()
                sharedViewModelLectures.lectures = networkData.fetchScheduel(html: item?.html ?? "No html", section: item?.section ?? "No section", group: item?.group ?? "No group", semiGroup: item?.semiGroup ?? "No semigroup")
                sharedViewModelLectures.disciplines = networkData.fetchDisciplinesFilter(lectures: sharedViewModelLectures.lectures)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .pickerStyle(.segmented)
        .onAppear {
                sharedViewModel.selectedSemiGroup = item?.semiGroup ?? "1"
        }
    }
}

#Preview {
    SettingsSemigroupsView(networkData: .constant(NetworkData(urlString: Links.I2)))
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedGroupsViewModel()) // Ensure the result of environmentObject is used
        .environmentObject(SharedLecturesViewModel())
        .padding()
}
