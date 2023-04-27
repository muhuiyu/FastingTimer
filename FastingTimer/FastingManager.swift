//
//  FastingManager.swift
//  FastingTimer
//
//  Created by Grace, Mu-Hui Yu on 4/27/23.
//

import Foundation

enum FastingState {
    case notStarted
    case fasting
    case feeding
}

enum FastingPlan: String {
    case oneMealADay = "23:1"
    case rolling48 = "47:1"
    case rolling72 = "71:1"
    case oneMealAWeek = "167:1"
    
    var fastingPeriod: Double {
        switch self {
        case .oneMealADay:
            return 23
        case .rolling48:
            return 47
        case .rolling72:
            return 71
        case .oneMealAWeek:
            return 167
        }
    }
}

class FastingManager: ObservableObject {
    @Published private(set) var fastingState: FastingState = .notStarted
    @Published private(set) var fastingPlan: FastingPlan = .oneMealAWeek
    @Published private(set) var startTime: Date {
        didSet {
            endTime = startTime.addingTimeInterval(fastingState == .fasting ? fastingTime : feedingTime)
        }
    }
    @Published private(set) var endTime: Date
    @Published private(set) var elasped: Bool = false
    @Published private(set) var elaspedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    
    var fastingTime: Double {
        return fastingPlan.fastingPeriod * 60 * 60
    }
    var feedingTime: Double {
        return 24 - fastingPlan.fastingPeriod * 60 * 60
    }
    
    init() {
        let scheduledTime = Date.now
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.oneMealADay.fastingPeriod * 60 * 60)
    }
    
    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
        elaspedTime = 0
    }
    
    func track() {
        guard fastingState != .notStarted else { return }
        elasped = endTime < Date()
        
        elaspedTime += 1
        
        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        progress = (elaspedTime / totalTime * 100).rounded() / 100
    }
}
