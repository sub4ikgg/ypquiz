//
//  QuizStatisticsProtocol.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 18.10.2025.
//

import Foundation

protocol QuizStatisticsServiceProtocol {
    func processStatistics(quizStatistics: QuizStatistics) -> QuizStatisticsResult
}
