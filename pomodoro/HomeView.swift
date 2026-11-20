//
//  HomeView.swift
//  pomodoro
//
//  Created by Alex H on 11/20/26.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var tab: AppTab
    
    var body: some View {
        Button("Start Focus") {
            tab = .timer
        }
    }
}
