//
//  QuizResultModel.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 18.10.2025.
//

import Foundation

struct QuizResultModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
