//
//  StarboardWidget.swift
//  StarboardWidget
//
//  Created by David Barsamian on 2/8/21.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct StarboardWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Goal")
                .font(.headline)
            Text("Date")
                .font(.subheadline)
                .italic()
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundColor(.yellow)
                .padding()
        }
    }
}

@main
struct StarboardWidget: Widget {
    let kind: String = "com.davidbarsam.starboard-goals"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StarboardWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Starboard")
        .description("Keep track of a goal and easily mark today off.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct StarboardWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StarboardWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            StarboardWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            StarboardWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
