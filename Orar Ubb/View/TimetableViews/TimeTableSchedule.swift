//
//  TimeTableSchedule.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 09.04.2024.
//

import SwiftUI

struct TopRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    var roundedCorners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let topLeftRadius = roundedCorners.contains(.topLeft) ? cornerRadius : 0
        let topRightRadius = roundedCorners.contains(.topRight) ? cornerRadius : 0
        
        path.move(to: CGPoint(x: minX, y: minY + topLeftRadius))
        path.addArc(center: CGPoint(x: minX + topLeftRadius, y: minY + topLeftRadius), radius: topLeftRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: maxX - topRightRadius, y: minY))
        path.addArc(center: CGPoint(x: maxX - topRightRadius, y: minY + topRightRadius), radius: topRightRadius, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.closeSubpath()
        
        return path
    }
}

//bottom rounder corners
struct BottomRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    var roundedCorners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let bottomLeftRadius = roundedCorners.contains(.bottomLeft) ? cornerRadius : 30
        let bottomRightRadius = roundedCorners.contains(.bottomRight) ? cornerRadius : 30
        
        path.move(to: CGPoint(x: minX, y: maxY - bottomLeftRadius))
        path.addArc(center: CGPoint(x: minX + bottomLeftRadius, y: maxY - bottomLeftRadius), radius: bottomLeftRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: maxX - bottomRightRadius, y: maxY))
        path.addArc(center: CGPoint(x: maxX - bottomRightRadius, y: maxY - bottomRightRadius), radius: bottomRightRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: maxX, y: minY))
        path.addLine(to: CGPoint(x: minX, y: minY))
        path.closeSubpath()
        
        return path
    }
}

struct TimeTableSchedule: View {
    @EnvironmentObject var sharedLecturesViewModel: SharedLecturesViewModel
    @FetchRequest(fetchRequest: SettingEntity.all())
    private var settings: FetchedResults<SettingEntity>
    var item: SettingEntity? {
        if settings.isEmpty {
            return nil
        } else {
            return settings[0]
        }
    }
    @FetchRequest(fetchRequest: Lecture.all())
    private var lectures: FetchedResults<Lecture>
    @Binding var selectedWeek: String
//    var filteredLectures: [Lecture] {
//        sharedLecturesViewModel.lectures.filter { $0.day == day && !sharedLecturesViewModel.disciplines.filter({$0.checked = true}).contains(where: $0.discipline) }
//    }
//    
//    var sortedLectures: [Lecture] {
//        filteredLectures.sorted(by: { $0.time ?? "00" < $1.time ?? "00" })
//    }
    var body: some View {
        VStack {
            List {
                ForEach(DaysOfWeek.days, id: \.self) { day in
                    Section {
                        ForEach(sharedLecturesViewModel.lectures.filter { lecture in
                            let isDayMatching = lecture.day == day
                            
                            // Filter to get checked disciplines
                            let checkedDisciplines = sharedLecturesViewModel.disciplines.filter { $0.checked }.map { $0.discipline }
                            
                            // Check if lecture's discipline is in checked disciplines
                            let isDisciplineChecked = !checkedDisciplines.contains(lecture.discipline)
                            
                            return isDayMatching && isDisciplineChecked
                        }.sorted(by: { $0.time ?? "00" < $1.time ?? "00" })) { lecture in
                            ZStack{
                                if sharedLecturesViewModel.lectures.filter({$0.day == day}).first == lecture {
                                    TopRoundedRectangle(cornerRadius: 0, roundedCorners: [.topLeft, .topRight])
                                        .fill(lecture.type == "Curs" ? Color.gray : Color.red)
                                        .frame(height: 100)
                                        .listRowInsets(EdgeInsets())
                                } else if sharedLecturesViewModel.lectures.filter({$0.day == day}).last == lecture {
                                    BottomRoundedRectangle(cornerRadius: 0, roundedCorners: [.bottomLeft, .bottomRight])
                                        .fill(lecture.type == "Curs" ? Color.gray : Color.red)
                                        .frame(height: 100)
                                        .listRowInsets(EdgeInsets())
                                } else {
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(lecture.type == "Curs" ? Color.gray : Color.red)
                                        .frame(height: 100)
                                        .listRowInsets(EdgeInsets())
                                }
                                HStack(){
                                    VStack {
                                        Text(lecture.time ?? "No time available!")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .padding(.leading, 10)
                                        if lecture.parity ?? "No Parity" == "sapt. 1" {
                                            Text("Week 1")
                                                .fontWeight(.medium)
                                                .foregroundColor(selectedWeek == "sapt. 1" ? Color.clear : .white)
                                                .padding(.leading, 10)
                                        } else if lecture.parity ?? "No Parity" == "sapt. 2" {
                                            Text("Week 2")
                                                .fontWeight(.medium)
                                                .foregroundColor(selectedWeek == "sapt. 2" ? Color.clear : .white)                                                .padding(.leading, 10)
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Text("\(lecture.type ?? "No type"): \(lecture.discipline ?? "No discipline available!")")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.5)
                                        Text(lecture.professor ?? "No professor available!")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        Text("Room: \(lecture.room ?? "No room")")
                                    }
                                    .padding(.trailing, 10)
                                    Spacer()
                                }
                                
                            }
                            .padding(-20)
                        }
                    } header: {
                        Text(day)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowSpacing(0)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparatorTint(.clear)
            .listRowBackground(Color.clear)
        }
        .onAppear {
//            print(lectures.count)
            sharedLecturesViewModel.lectures = Array(lectures).filter { lecture in
                // Filter to get checked disciplines
                let checkedDisciplines = sharedLecturesViewModel.disciplines.filter { $0.checked }.map { $0.discipline }
                
                // Check if lecture's discipline is in checked disciplines
                let isDisciplineChecked = !checkedDisciplines.contains(lecture.discipline)
                
                return isDisciplineChecked
            }
        }
    }
}



#Preview {
    TimeTableSchedule(selectedWeek: .constant("1"))
        .environmentObject(SharedLecturesViewModel())
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
}

