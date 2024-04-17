//  GorupsView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 06.04.2024.

import SwiftUI

struct SettingsGroupsView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var sharedViewModel: SharedGroupsViewModel
    @FetchRequest(fetchRequest: SettingEntity.all())
    private var items: FetchedResults<SettingEntity>
    @Binding var networkData: NetworkData
    @State var groupSelected: String = ""
    var item: SettingEntity? {
        if items.isEmpty {
            return nil
        } else {
            return items[0]
        }
    }
    
    //MARK: - Body
    var body: some View {
        Picker("Group", selection: $groupSelected) {
            Text("Select")
                .tag("Select")
            ForEach(sharedViewModel.groups, id: \.self) {group in
                Text(group.components(separatedBy: " ")[1])
                    .tag(group.components(separatedBy: " ")[1])
            }
        }
        .tint(.primary)
        .onChange(of: groupSelected, {
            if groupSelected != "Select" && groupSelected != item?.group{
                sharedViewModel.selectedSemiGroup = groupSelected
                item?.group = groupSelected
                do {
                    try viewContext.save()
                    sharedViewModel.selectedSemiGroup = ""
                } catch let error {
                    print("Error saving group: \(error)")
                }
            }
        })
        .onAppear {
            DispatchQueue.main.async {
                if item?.html != "" {
                    sharedViewModel.groups = networkData.fetchGroupsForSection(html: item?.html ?? "No html")
                    if item?.group != "" {
                        groupSelected = item?.group ?? "No group"
                    } else {
                        groupSelected = "Select"
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsGroupsView(networkData: .constant(NetworkData(urlString: Links.I2)))
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedGroupsViewModel()) // Ensure the result of environmentObject is used
}
