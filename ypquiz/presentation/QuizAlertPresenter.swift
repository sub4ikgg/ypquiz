//
//  QuizAlertPresenter.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 18.10.2025.
//

import Foundation
import UIKit

final class QuizAlertPresenter {
    func show(in vc: UIViewController, model: QuizAlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: model.buttonText, style: .default) { _ in
                model.completion()
            }
        )

        vc.present(alert, animated: true, completion: nil)
    }
} 
