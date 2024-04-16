//
//  Widgets.swift
//  Widgets
//
//  Created by Stefan Miloiu on 13.04.2024.
//

import WidgetKit
import SwiftUI
import CoreData


struct Provider: TimelineProvider {
    
    private let tools = WidgetTools()
    
    private let container = CoreDataProvider.shared.persistenceContainer
    private let context = CoreDataProvider.shared.viewContext
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), lecture: Lecture(context: CoreDataProvider.shared.viewContext))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), lecture: Lecture(context: CoreDataProvider.shared.viewContext))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Perform Core Data operations on the main queue context
        // Note: You may want to move this to a background context if fetching large amounts of data
        do {
            let lectures = try container.viewContext.fetch(Lecture.all()).filter( { tools.getWeekFromDate() == tools.dayDictionary[$0.day ?? "Sunday"] && tools.checkBetween(interval: $0.time ?? "00-00") /*tools.dayDictionary[tools.getWeekFromDate()]*/
                && tools.getLecturesNotHidden(discipline: $0.discipline ?? "Disciplina") } )
            print("Fetched \(lectures.count) lectures.")
            // Create timeline entries with fetched lectures
            let entries: [SimpleEntry] = [SimpleEntry(date: Date(), lecture: lectures.count > 0 ? lectures[0] : nil)]
            //            let refreshDate = Date().advanced(by: 2 * 60 * 60) // Refresh every 2 hours
            // Calculate the next hour for refresh
            let currentDate = Date()
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: currentDate)
            let nextHour = currentHour + 1
            let nextHourDate = calendar.date(bySettingHour: nextHour, minute: 0, second: 0, of: currentDate) ?? Date()
            let refreshDate = nextHourDate
            
            let timeline = Timeline(entries: entries, policy: .after(refreshDate))
            completion(timeline)
        } catch {
            print("Failed to fetch lectures: \(error)")
            completion(Timeline(entries: [], policy: .atEnd))
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let lecture: Lecture?
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry
    
    private let tools = WidgetTools()
    @State var weekend: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top){
                Text(tools.getWeekFromDateAbv())
                    .font(.title)
                    .foregroundStyle(.red.opacity(0.6))
                Text("\(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none).components(separatedBy: " ").first ?? "Always true") \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none).components(separatedBy: " ")[1])")
                    .multilineTextAlignment(.center)
            }
            if entry.lecture == nil {
                Text("No classes")
                    .font(.subheadline)
                    .foregroundStyle(weekend ? .gray.opacity(0.6) : .clear)
                    .lineLimit(1)
            } else {
                HStack{
                    VStack{
                        Text(entry.lecture?.time ?? "00-00")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .foregroundStyle(!weekend ? .gray.opacity(0.75) : .clear)
                            .lineLimit(1)
                        Text(entry.lecture?.room ?? "No room")
                            .font(.subheadline)
                            .foregroundStyle(!weekend ? .gray.opacity(0.75) : .clear)
                            .lineLimit(1)
                        if entry.lecture?.parity == "sapt. 1" {
                            Text("Week 1")
                                .font(.subheadline)
                                .foregroundStyle(!weekend ? .gray.opacity(0.75) : .clear)
                                .lineLimit(1)
                        } else if entry.lecture?.parity == "sapt. 2" {
                            Text("Week 2")
                                .font(.subheadline)
                                .foregroundStyle(!weekend ? .gray.opacity(0.75) : .clear)
                                .lineLimit(1)
                        }
                        
                    }
                    .padding(.bottom, 20)
                    Text(entry.lecture?.discipline ?? "No discipline")
                        .font(.subheadline)
                        .foregroundStyle(!weekend ? .gray.opacity(0.9) : .clear)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                }
                Text(entry.lecture?.professor ?? "No professor")
                    .font(.system(size: 12))
                    .foregroundStyle(!weekend ? .gray.opacity(0.9) : .clear)
                    .lineLimit(1)
            }
        }
        .onAppear {
            
            if tools.getWeekFromDateAbv() == "Sun" || tools.getWeekFromDateAbv() == "Sat" {
                weekend = true
            } else {
                weekend = false
            }
        }
    }
}

struct Widgets: Widget {
    let kind: String = "Widgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        //        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Ubb Schedule")
        .description("Widget for current day schedule.")
    }
}



#Preview(as: .systemSmall) {
    Widgets()
} timeline: {
    SimpleEntry(date: Date(), lecture: Lecture(context: CoreDataProvider.shared.viewContext))
}
