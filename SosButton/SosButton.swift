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
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    
       /* var entries: [SosButtonEntry] = []
        entries.append(SosButtonEntry(date: Date()) */

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

/*
struct SosButtonEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SosButtonEntry {
        SosButtonEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SosButtonEntry) -> ()) {
        
        let entry = SosButtonEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SosButtonEntry] = []
        entries.append(SosButtonEntry(date: Date(), configuration: configuration))

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

@main
struct Widget_Wid: Widget {
    let kind: String = "SOS Button"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SosButtonView(entry: entry)
        }
        .configurationDisplayName(kind)
        .description("Tap this Widget to Call the Police")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct SosButtonView: View {

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
} */

/*struct Widget_Wid_Previews: PreviewProvider {
    static var previews: some View {
        SosButtonView(entry: SosButtonEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
} */
