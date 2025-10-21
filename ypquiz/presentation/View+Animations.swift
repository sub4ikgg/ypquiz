//
//  View+Animations.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 19.10.2025.
//

import Foundation
import UIKit

extension UIView {
    func setVisibility(_ visible: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if visible {
                isHidden = false
                alpha = 0
                UIView.animate(withDuration: duration) {
                    self.alpha = 1
                }
            } else {
                UIView.animate(withDuration: duration, animations: {
                    self.alpha = 0
                }) { _ in
                    self.isHidden = true
                }
            }
        } else {
            isHidden = !visible
            alpha = visible ? 1 : 0
        }
    }
}
