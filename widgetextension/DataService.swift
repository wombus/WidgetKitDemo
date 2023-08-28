//
//  DataService.swift
//  widgetextensionExtension
//
//  Created by Peter Napoli on 8/27/23.
//

import Foundation
import SwiftUI

struct DataService {
    @AppStorage("streak", store: UserDefaults(suiteName: "group.com.napoli.WidgetDemo")) private var streak = 0
    
    func log() {
        streak += 1
    }
    
    func progress() -> Int {
        return streak
    }
    
}
