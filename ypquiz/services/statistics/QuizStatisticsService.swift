//
//  QuizStatisticsService.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 18.10.2025.
//

import Foundation

final class QuizStatisticsService: QuizStatisticsServiceProtocol {
    func processStatistics(quizStatistics: QuizStatistics) -> QuizStatisticsResult {
        let defaults = UserDefaults.standard
        let previousRecord = defaults.integer(forKey: UserDefaultsConstants.recordKey)
        let previousRecordTotal = defaults.integer(forKey: UserDefaultsConstants.recordTotalKey)
        
        let quizzesPlayed = defaults.integer(forKey: UserDefaultsConstants.quizzesPlayedKey) + 1
        let recordDate = (defaults.object(forKey: UserDefaultsConstants.recordDateKey) as? Date) ?? Date()
        
        let currentAccuracy = (Double(quizStatistics.score) / Double(quizStatistics.total)) * 100
        let previousAverage = defaults.double(forKey: UserDefaultsConstants.averageAccuracyKey)
        let newAverageAccuracy = defaults.object(forKey: UserDefaultsConstants.averageAccuracyKey) != nil ?
            (previousAverage * Double(quizzesPlayed) + currentAccuracy) / Double(quizzesPlayed + 1) : currentAccuracy
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        
        saveQuizzesPlayed(quizzesPlayed: quizzesPlayed)
        saveAverageAccuracy(averageAccuracy: newAverageAccuracy)
        
        let isNewRecord = quizStatistics.score > previousRecord
        if isNewRecord {
            let newRecordDate = Date()
            
            saveRecord(
                score: quizStatistics.score,
                total: quizStatistics.total,
                date: newRecordDate
            )
            
            return QuizStatisticsResult(
                score: quizStatistics.score,
                total: quizStatistics.total,
                quizzesPlayed: quizzesPlayed,
                record: "\(quizStatistics.score)/\(quizStatistics.total) (\(dateFormatter.string(from: newRecordDate)))",
                averageAccuracy: newAverageAccuracy
            )
        }
        
        return QuizStatisticsResult(
            score: quizStatistics.score,
            total: quizStatistics.total,
            quizzesPlayed: quizzesPlayed,
            record: "\(previousRecord)/\(previousRecordTotal) (\(dateFormatter.string(from: recordDate)))",
            averageAccuracy: newAverageAccuracy
        )
    }
    
    private func saveRecord(score: Int, total: Int, date: Date) {
        UserDefaults.standard.set(score, forKey: UserDefaultsConstants.recordKey)
        UserDefaults.standard.set(total, forKey: UserDefaultsConstants.recordTotalKey)
        UserDefaults.standard.set(date, forKey: UserDefaultsConstants.recordDateKey)
    }
    
    private func saveQuizzesPlayed(quizzesPlayed: Int) {
        UserDefaults.standard.set(quizzesPlayed, forKey: UserDefaultsConstants.quizzesPlayedKey)
    }
    
    private func saveAverageAccuracy(averageAccuracy: Double) {
        UserDefaults.standard.set(averageAccuracy, forKey: UserDefaultsConstants.averageAccuracyKey)
    }
}
