//
//  LockScreenWidget.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 16.04.2024.
//

import Foundation
import SwiftUI
import WidgetKit

struct WidgetsEntryViewLockScreen : View {
    var entry: Provider.Entry
    
    private let tools = WidgetTools()
    @State var weekend: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            if entry.lecture == nil {
                Text("No classes today")
                    .font(.subheadline)
                    .lineLimit(1)
            } else {
                VStack{
                    HStack{
                        Text(entry.lecture?.time ?? "10:00")
                            .font(.system(size: 15))
                            .fontWeight(.heavy)
                            .foregroundStyle(!weekend ? .gray.opacity(0.75) : .clear)
                            .lineLimit(1)
                        Text(entry.lecture?.room ?? "L336")
                            .font(.system(size: 15))
                            .foregroundStyle(!weekend ? .gray.opacity(0.75) : .clear)
                            .lineLimit(1)
                        if entry.lecture?.parity == "sapt. 1"{
                            Text("Week 1")
                                .font(.system(size: 12.5))
                                .foregroundStyle(!weekend ? .gray.opacity(0.9) : .clear)
                                .lineLimit(1)
                        } else if entry.lecture?.parity == "sapt. 2"{
                            Text("Week 2")
                                .font(.system(size: 12.5))
                                .foregroundStyle(!weekend ? .gray.opacity(0.9) : .clear)
                                .lineLimit(1)
                        } else if entry.lecture?.parity == nil{
                            Text("Week")
                                .font(.system(size: 12.5))
                                .foregroundStyle(!weekend ? .gray.opacity(0.9) : .clear)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    Text(entry.lecture?.discipline ?? "Programming in Swift")
                        .font(.system(size: 15))
                        .foregroundStyle(!weekend ? .gray.opacity(0.9) : .clear)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
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

struct WidgetsLockScreen: Widget {
    let kind: String = "WidgetsLockScreen"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetsEntryViewLockScreen(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetsEntryViewLockScreen(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.accessoryRectangular, .accessoryInline])
        .configurationDisplayName("Ubb Schedule")
        .description("Widget for current day schedule.")
    }
}
