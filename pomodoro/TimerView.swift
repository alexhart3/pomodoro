//
//  TimerView.swift
//  pomodoro
//
//  Created by Alex H on 11/20/26.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        VStack {
            Text("25:00")
                .font(Font.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "play")
                        Text("Start")
                    }
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "pause")
                        Text("Pause")
                    }
                }
            }
            .buttonStyle(TimerButtonStyle())
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "stop")
                        Text("Stop")
                    }
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                        Text("Reset")
                    }
                }
            }
            .buttonStyle(TimerButtonStyle())
        }
        
        
    }
}

struct TimerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.primary)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary, lineWidth: 2)
            }
    }
}

#Preview {
    TimerView()
}
