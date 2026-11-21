//
//  TimerView.swift
//  pomodoro
//
//  Created by Alex H on 11/20/26.
//

import SwiftUI

struct TimerView: View {
    
    @State private var timeRemaining: Int = 25 * 60
    @State private var isRunning: Bool = false
    @State private var endDate: Date?
    
    var body: some View {
        VStack {
            if isRunning {
                TimelineView(.periodic(from: Date.now, by: 1)) { context in
                    let remaining = max(
                        0,
                        Int(ceil(endDate?.timeIntervalSince(context.date) ?? 0))
                    )

                    Text(secondsToTime(remaining))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            } else {
                Text(secondsToTime(timeRemaining))
                    .font(Font.largeTitle)
                    .fontWeight(.bold)
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    if isRunning {
                        return
                    }
                    endDate = Date().addingTimeInterval(TimeInterval(timeRemaining))
                    isRunning = true
                }) {
                    HStack {
                        Image(systemName: "play")
                        Text("Start")
                    }
                }
                
                Button(action: {
                    if !isRunning {
                        return
                    }
                    
                    timeRemaining = Int(ceil(endDate?.timeIntervalSinceNow ?? 0))
                    isRunning = false
                }) {
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

func secondsToTime(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let seconds = seconds % 60
    
    return String(format: "%02d:%02d", minutes, seconds)
}

#Preview {
    TimerView()
}
