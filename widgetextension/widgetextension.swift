//
//  widgetextension.swift
//  widgetextension
//
//  Created by Peter Napoli on 8/27/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider { //this supplies the actual data to your widget
    
    
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), streak: data.progress())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), streak: data.progress())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, streak: data.progress())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry { //this is the data for a single snapshot
    let date: Date
    let streak: Int
}

struct widgetextensionEntryView : View {
    
    var entry: Provider.Entry
    let data = DataService()
    
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 20)
            
            let pct = Double(data.progress()) / 50.0
            
            Circle()
                .trim(from: 0, to: pct)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(-90))
            
            VStack {
                Text("Streak")
                    .font(.title)
                Text(String(data.progress()))
                    //.font(.system(size: 70))
                    .bold()
            }
            .foregroundStyle(.white)
            .fontDesign(.rounded)
            
            
        }
        .padding()
        
        
//        Text("Streak:")
//        Text(String(data.progress()))
//        Text(entry.date, style: .time)
        
        
        
        //this section is what is actually being displayed on your widget
    }
    
}

struct widgetextension: Widget {
    let kind: String = "widgetextension" // like the identifier for your widget

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in  //this closure is the actual view of your widget
            widgetextensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget") //just some metadata for your widget
        .description("This is an example widget.") //more metadata for your widget
        .supportedFamilies([.systemSmall]) //defines the size type of your widget
    }
}

struct widgetextension_Previews: PreviewProvider {

    static var previews: some View {
        widgetextensionEntryView(entry: SimpleEntry(date: Date(), streak: 4))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


// How StaticConfiguration Widgets work
//StaticConfiguration is like the most basic widget type
// You have to first pass in the kind, which is "widgetextension" here, and what called the identifier for our widget
// widget kind is important because in our actual app we can issue commands to update x widget and that's where we will refer to it by kind
//the Provider is the supplier of the data to the widget
//Widgets are not always "live" i.e. being fed data, so what the Timeline in the Provider struct does is tell the widget what to show (i.e. a snapshot) at different points of time in the day
//The widget asks the TimelineProvider for data, it doesn't just ask for a snapshot of what should be shown right now but also for snapshots of what should be shown in the foreseeable future, so your Provider can supply snapshots for now, 1 hour later, 2 hours later, 3 hours later and what you widget does is takes all of those snapshots and creates what your view should look like ahead of time, so when the next time comes it will take that pre rendered view and render it, it only asks for data at certain times there are ways for you to manually trigger your widget to ask the Provider for a fresh set of data snapshots, only allowed a certain budget to do that. So no app can constantly try to keep refreshing the widget and hogging all of the system resources
// there are certain scenarios when you can ask  your widget to refresh it's snapshot data and it does not count against your app's budget, one scenario is when you launch your app and it's in the foreground.
//the other scenario where you can update your widget without counting toward your app's budget is when the user taps your widget

