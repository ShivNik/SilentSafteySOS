//
//  SosButton.swift
//  SosButton
//
//  Created by Shivansh Nikhra on 7/10/22.
//

import WidgetKit
import SwiftUI
import Intents


struct SosButtonEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SosButtonEntry {
        SosButtonEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SosButtonEntry) -> ()) {
        let entry = SosButtonEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SosButtonEntry>) -> ()) {
        
        let entry = SosButtonEntry(date: Date())
        completion(Timeline(entries: [entry], policy: .never))
    }
}
                       
struct WidgetStaticTestEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        returnView()
    }
    
    func returnView() -> some View {
        return ZStack {
            Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 1.00)
                .edgesIgnoringSafeArea(.all)
            
            Image("SosButton")
                .resizable()
                .scaledToFill()
        }
    }
}

@main
struct WidgetStaticTest: Widget {
    let kind: String = "SOS Button"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetStaticTestEntryView(entry: entry)
        }
        .configurationDisplayName(kind)
        .description("Tap this Widget to Call the Police")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
