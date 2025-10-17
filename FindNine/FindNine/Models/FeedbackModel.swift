//
//  FeedbackModel.swift
//  FindNine
//
//  Created by Zhao on 2025/10/16.
//

import Foundation
import DateToolsSwift

struct FeedbackModel: Codable {
    var nineContent: String
    var nineDate: Date

    func findFormattedDate() -> String {
        return nineDate.format(with: "yyyy.MM.dd HH:mm")
    }
}

class FeedbackGuanliqi {
    static let shared = FeedbackGuanliqi()
    private let nineKey = "FeedbackKey"

    private init() {}

    func findSaveFeedback(nineFeedback: FeedbackModel) {
        var nineFeedbacks = findAllFeedbacks()
        nineFeedbacks.insert(nineFeedback, at: 0)

        // Keep only last 100 feedbacks
        if nineFeedbacks.count > 100 {
            nineFeedbacks = Array(nineFeedbacks.prefix(100))
        }

        if let nineData = try? JSONEncoder().encode(nineFeedbacks) {
            UserDefaults.standard.set(nineData, forKey: nineKey)
        }
    }

    func findAllFeedbacks() -> [FeedbackModel] {
        guard let nineData = UserDefaults.standard.data(forKey: nineKey),
              let nineFeedbacks = try? JSONDecoder().decode([FeedbackModel].self, from: nineData) else {
            return []
        }
        return nineFeedbacks
    }

    func findClearAllFeedbacks() {
        UserDefaults.standard.removeObject(forKey: nineKey)
    }

    func findDeleteFeedback(at index: Int) {
        var nineFeedbacks = findAllFeedbacks()
        guard index < nineFeedbacks.count else { return }
        nineFeedbacks.remove(at: index)

        if let nineData = try? JSONEncoder().encode(nineFeedbacks) {
            UserDefaults.standard.set(nineData, forKey: nineKey)
        }
    }
}
