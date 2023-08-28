//
//  ContentView.swift
//  WidgetDemo
//
//  Created by Peter Napoli on 8/27/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @AppStorage("streak", store: UserDefaults(suiteName: "group.com.napoli.WidgetDemo")) var streak = 0
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 20)
                    
                    let pct = Double(streak) / 50.0
                    
                    Circle()
                        .trim(from: 0, to: pct)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("Streak")
                            .font(.largeTitle)
                        Text(String(streak))
                            .font(.system(size: 70))
                            .bold()
                    }
                    .foregroundStyle(.white)
                    .fontDesign(.rounded)
                    
                    
                }
                .padding(.horizontal, 50)
                

                Spacer()
                

                Button(action: {
                    streak += 1
                    //Manually reload the widget
                    WidgetCenter.shared.reloadTimelines(ofKind: "widgetextension")
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.blue)
                            .frame(height: 50)
                        Text("+1")
                            .foregroundStyle(.white)
                    }
                })
                .padding(.horizontal)
            }
            
        }
       
        

        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
