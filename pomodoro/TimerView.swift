//
//  TimerView.swift
//  pomodoro
//
//  Created by Alex H on 11/20/26.
//

import SwiftUI

struct TimerView: View {
    
    private var workTime: Int = 1
    private var breakTime: Int = 2
    @State private var timeRemaining: Int = 1 * 60
    @State private var isRunning: Bool = false
    @State private var endDate: Date?
    @State private var isBreak: Bool = false
    
    // TODO: Make timer auto switch between 25 minutes and 5 minutes, also dont hard code the buttons to 25 minutes and 5 minutes have them be dynamic using time remaining
    
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
                    endDate = nil
                }) {
                    HStack {
                        Image(systemName: "pause")
                        Text("Pause")
                    }
                }
            }
            .buttonStyle(TimerButtonStyle())
            
            HStack(spacing: 12) {
                Button(action: {
                    timeRemaining = workTime * 60
                    endDate = nil
                    isRunning = false
                    isBreak = false
                }) {
                    HStack {
                        Image(systemName: "stop")
                        Text("Stop")
                    }
                }
                
                Button(action: {
                    if isRunning {
                        endDate = Date().addingTimeInterval(TimeInterval(timeRemaining))
                    } else {
                        endDate = nil
                    }
                    timeRemaining = workTime * 60
                    isBreak = false
                }) {
                    HStack {
                        Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                        Text("Reset")
                    }
                }
            }
            .buttonStyle(TimerButtonStyle())
        }
        .task(id: endDate) {
            await waitForTimer()
        }
        
        
    }
    
    private func secondsToTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func switchSession() {
        if isBreak {
            timeRemaining = workTime * 60
        } else {
            timeRemaining = breakTime * 60
        }

        isBreak.toggle()
        endDate = Date.now.addingTimeInterval(TimeInterval(timeRemaining))
    }
    
    @MainActor
    private func waitForTimer() async {
        guard let deadline = endDate, isRunning else {
            return
        }

        let secondsLeft = max(0, deadline.timeIntervalSinceNow)
        
        print("Starting sleep. Seconds left: \(secondsLeft)")
        do {
            try await Task.sleep(for: .seconds(secondsLeft), tolerance: .zero)
        } catch {
            print("Sleep cancelled")
            return
        }
        print("Woke up! Seconds past deadline: \(Date.now.timeIntervalSince(deadline))")

        guard !Task.isCancelled,
              isRunning,
              endDate == deadline,
              Date.now >= deadline else {
            return
        }

        switchSession()
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
