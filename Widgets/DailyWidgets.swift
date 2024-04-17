import SwiftUI
import WidgetKit


struct ProviderDaily: TimelineProvider {
    
    private let tools = WidgetTools()
    
    private let container = CoreDataProvider.shared.persistenceContainer
    private let context = CoreDataProvider.shared.viewContext
    
    func placeholder(in context: Context) -> SimpleDailyEntry {
        SimpleDailyEntry(date: Date(), lectures: [Lecture(context: CoreDataProvider.shared.viewContext)])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleDailyEntry) -> ()) {
        var lecturesList: [Lecture] = []
        let lectureOne = Lecture(context: CoreDataProvider.shared.viewContext)
        lectureOne.discipline = "Metode avansate de programare"
        lectureOne.room = "L336"
        lectureOne.time = "12-00"
        lectureOne.type = "Lab"
        lectureOne.professor = "Teacher Name"
        lectureOne.day = "Monday"
        lectureOne.parity = " "
        let lectureTwo = Lecture(context: CoreDataProvider.shared.viewContext)
        lectureTwo.discipline = "Arhitectura sistemelor de calcul"
        lectureTwo.room = "L001"
        lectureTwo.time = "16-00"
        lectureTwo.type = "Lab"
        lectureTwo.professor = "Teacher Name"
        lectureTwo.day = "Monday"
        lectureTwo.parity = " "
        let lectureThree = Lecture(context: CoreDataProvider.shared.viewContext)
        lectureThree.discipline = "Baze de date"
        lectureThree.room = "C510"
        lectureThree.time = "18-00"
        lectureThree.type = "Curs"
        lectureThree.professor = "Teacher Name"
        lectureThree.day = "Monday"
        lectureThree.parity = "sapt. 1"
        lecturesList.append(lectureOne)
        lecturesList.append(lectureTwo)
        lecturesList.append(lectureThree)
        let entry = SimpleDailyEntry(date: Date(), lectures: lecturesList)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let lectures = try container.viewContext.fetch(Lecture.all()).filter( { tools.getWeekFromDate() == tools.dayDictionary[$0.day ?? "Sunday"] && tools.checkRemainingLectures(interval: $0.time ?? "00-00") /*tools.dayDictionary[tools.getWeekFromDate()]*/
                && tools.getLecturesNotHidden(discipline: $0.discipline ?? "Discipline")} )
            //only the first 3 lectures of the day
            var lecturesFiltered = lectures
            if lecturesFiltered.count > 3 {
                lecturesFiltered.removeSubrange(3..<lecturesFiltered.count)
            }
            // Create timeline entries with fetched lectures
            let entries: [SimpleDailyEntry] = [SimpleDailyEntry(date: Date(), lectures: lecturesFiltered)]
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

struct SimpleDailyEntry: TimelineEntry {
    let date: Date
    let lectures: [Lecture]
}

struct WidgetsEntryDailyView : View {
    var entry: ProviderDaily.Entry
    
    private let tools = WidgetTools()
    @State var weekend: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top){
                Text(tools.getWeekFromDateAbv())
                    .font(.title3)
                    .foregroundStyle(.red.opacity(0.6))
                Text("\(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none).components(separatedBy: " ").first ?? "Always true") \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none).components(separatedBy: " ")[1])")
                    .multilineTextAlignment(.center)
            }
            if entry.lectures.isEmpty {
                Text("No classes. Enjoy your day!😴")
                    .font(.subheadline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            } else {
                ForEach(entry.lectures.indices, id: \.self) { index in
                    let lecture = entry.lectures[index]
                    HStack{
                        VStack{
                            Text(lecture.time ?? "Hour")
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .foregroundStyle(!weekend ? .gray.opacity(0.75) : .clear)
                                .lineLimit(1)
                            // Additional lecture details
                            Text(lecture.type ?? "Type")
                                .font(.subheadline)
                                .foregroundStyle(!weekend ? .gray.opacity(0.75) : .clear)
                                .lineLimit(1)
                        }
                        .padding(.leading, 20)
                        Spacer()
                        Text(lecture.discipline ?? "Discipline")
                            .font(.subheadline)
                            .foregroundStyle(!weekend ? .gray.opacity(0.9) : .clear)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                }
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
struct WidgetDaily: Widget {
    let kind: String = "WidgetDaily"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProviderDaily()) { entry in
            WidgetsEntryDailyView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
        .configurationDisplayName("Daily lectures")
        .description("This widget will display all your daily lectures remaining")
    }
}


struct WidgetDaily_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsEntryDailyView(entry: SimpleDailyEntry(date: Date(), lectures: [Lecture(context: CoreDataProvider.shared.viewContext),
                                                                               Lecture(context: CoreDataProvider.shared.viewContext),
                                                                               Lecture(context: CoreDataProvider.shared.viewContext)]))
        .containerBackground(.fill.tertiary, for: .widget)
        //            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

