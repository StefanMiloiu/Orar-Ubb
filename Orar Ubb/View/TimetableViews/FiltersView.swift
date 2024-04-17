//
//  FiltersView.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 14.04.2024.
//

import SwiftUI
import WidgetKit

struct FiltersView: View {
    @EnvironmentObject var viewModel: SharedLecturesViewModel
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(fetchRequest: DisciplineFilter.all())
    var disciplines: FetchedResults<DisciplineFilter>
    @State var isChecked = false
    var body: some View {
        List{
            Section {
                HStack{
                    Spacer()
                    Text("Check the courses you want to hide.")
                        .font(.headline)
                        .padding()
                        .multilineTextAlignment(.center)
                    Image(systemName: "eye.slash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                    
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            Section {
                ForEach(viewModel.disciplines.indices, id: \.self) { index in
                    let discipline = viewModel.disciplines[index]
                    Toggle(isOn: $viewModel.disciplines[index].checked, label: {
                        Text(/*\(index)-*/"\(discipline.discipline ?? "Discipline")")
                    })
                    .onChange(of: viewModel.disciplines[index].checked) {
                        save(filter: viewModel.disciplines[index])
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
            }
        }
        .onAppear {
            if !disciplines.isEmpty {
                viewModel.disciplines = Array(disciplines)
            }
        }
    }
    
    func save(filter: DisciplineFilter) {
        do {
            let index = viewModel.disciplines.firstIndex(of: filter)
            if let index = index {
                viewModel.disciplines[index].checked = filter.checked
                try viewContext.save()
            }
        } catch let error {
            print("Error saving: \(error)")
        }
    }
}

#Preview {
    FiltersView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedLecturesViewModel())
    
}
