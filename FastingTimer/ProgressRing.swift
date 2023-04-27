//
//  ProgressRing.swift
//  FastingTimer
//
//  Created by Grace, Mu-Hui Yu on 4/27/23.
//

import SwiftUI

struct ProgressRing: View {
    @EnvironmentObject var fastingManager: FastingManager
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            // MARK: - Placeholder Ring
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            // MARK: - Colored Ring
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
                .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4061516523, green: 0.5614333749, blue: 0.9903351665, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4290391803, blue: 0.9360901117, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7350289226, blue: 0.9303470254, alpha: 1)), Color(#colorLiteral(red: 0.419424206, green: 0.9728081822, blue: 0.9604642987, alpha: 1)), Color(#colorLiteral(red: 0.4928803444, green: 0.6621747613, blue: 0.9854630828, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 15.0 , lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: fastingManager.progress)
            
            VStack(spacing: 30) {
                if fastingManager.fastingState == .notStarted {
                    // MARK: - Upcoming Fast
                    
                    VStack(spacing: 5) {
                        Text("Upcoming fast")
                            .opacity(0.7)
                        
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                } else {
                    // MARK: - Elapsed Time
                    
                    VStack(spacing: 5) {
                        Text("Elapsed time (\(fastingManager.progress.formatted(.percent))")
                            .opacity(0.7)
                        
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    VStack(spacing: 5) {
                        if fastingManager.elasped {
                            Text("Extra time")
                                .opacity(0.7)
                        } else {
                            Text("Remaining time (\((1 - fastingManager.progress).formatted(.percent))")
                                .opacity(0.7)
                        }
                        Text(fastingManager.endTime, style: .timer)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .frame(width: 250, height: 250)
        .padding()
        .onReceive(timer) { _ in
            fastingManager.track()
        }
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
            .environmentObject(FastingManager())
    }
}
