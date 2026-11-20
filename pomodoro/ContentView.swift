//
//  ContentView.swift
//  pomodoro
//
//  Created by Alex H on 11/20/26.
//

import SwiftUI

enum AppTab {
    case home
    case timer
    case stats
}

struct ContentView: View {
    
    @State private var tab: AppTab = .home
    
    var body: some View {
        TabView(selection:$tab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView(tab: $tab)
            }
            
            Tab("Timer", systemImage: "timer", value: .timer) {
                TimerView()
            }
            
            Tab("Stats", systemImage: "chart.bar.fill", value: .stats) {
                StatsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
