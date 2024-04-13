//
//  SettingsView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 06.04.2024.
//

import SwiftUI

struct SettingsView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var sharedViewModel: SharedGroupsViewModel
    @FetchRequest(fetchRequest: SettingEntity.all())
    private var items: FetchedResults<SettingEntity>
    @State var networkData = NetworkData(urlString: Links.I2)
    private var item: SettingEntity? {
        if items.isEmpty {
            return nil
        } else {
            return items[0]
        }
    }

    
    //MARK: - Body
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    NavigationLink {
                        SettingsYearView(networkData: $networkData)
                    } label: {
                        if item == nil{
                            Text("Year")
                        }else {
                            Text("Year (\(String(describing: item?.section?.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? "No selection")))")
                        }
                    }//:NavigationLink
                    
                    Section{
                        SettingsGroupsView(networkData: $networkData)
                        Text("Semigroup")
                            .frame(maxWidth: .infinity, alignment: .center)
                        SettingsSemigroupsView(networkData: $networkData)
                            .listRowSeparator(.hidden)
                    }//: Section
                    
                }//: List
                
            }//: VStack
            .navigationTitle("Settings")
        }//:NavigationStack
        .tint(.black)
    }
}



#Preview {
    SettingsView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedGroupsViewModel()) // Ensure the result of environmentObject is used
        .environmentObject(SharedLecturesViewModel())
}


