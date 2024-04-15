import SwiftUI
import CoreData

struct SettingsYearView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var sharedViewModel: SharedGroupsViewModel
    @FetchRequest(fetchRequest: SettingEntity.all())
    private var items: FetchedResults<SettingEntity>
    @Environment(\.dismiss) var dismiss
    let filter = FilterYearsSettings()
    @Binding var networkData: NetworkData
    @State var savingErrorAlert = false
    
    //MARK: - Body
    var body: some View {
        // Inside the body of SettingsYearView
        VStack {
            List {
                //List of sections and links
                ForEach(Links.names, id: \.self) { name in
                    Section(header: Text(name).font(.subheadline)) {
                        if let nameIndex = Links.names.firstIndex(of: name),
                           !Links.links.isEmpty && nameIndex < Links.links.count {
                            ForEach(Links.links[nameIndex], id: \.self) { link in
                                Button(action: {
                                    /*print(name)*/
                                    // Fetch html for the link
                                    networkData.getHTML(url: link) { html in
                                        CoreDataProvider.deleteAllData()
                                        // Save or update the setting
                                        self.saveOrUpdateSetting(section: link, html: html ?? "No html", viewContext: self.viewContext)
                                        // Extract groups from the html
                                        DispatchQueue.main.async {
                                            sharedViewModel.groups = networkData.fetchGroupsForSection(html: html!)
                                            sharedViewModel.selectedSemiGroup = ""
                                        }
                                    }
                                    dismiss()
                                }, label: {
                                    Text(filter.parseURL(url: link) ?? "No name")
                                        .padding(.leading, 10)
                                        .tint(.red.opacity(0.7))
                                })
                            }
                        } else {
                            Text("No links available")
                        }
                    }
                }
            }
        }
        .alert(isPresented: $savingErrorAlert) {
            Alert(title: Text("Error"), message: Text("Failed to save the setting"), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Settings")
    }
    
    func saveOrUpdateSetting(section: String, html: String, viewContext: NSManagedObjectContext) {
        if items.count == 0 {
            let newSetting = SettingEntity(context: viewContext)
            newSetting.section = section
            newSetting.group = ""
            newSetting.semiGroup = ""
            newSetting.html = html
        } else {
            items[0].section = section
            items[0].html = html
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            savingErrorAlert = true
            print("Unresolved error \(nsError)")
        }
    }

}


#Preview {
    SettingsYearView(networkData: .constant(NetworkData(urlString: Links.I2)))
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(SharedGroupsViewModel()) // Ensure the result of environmentObject is used
}
