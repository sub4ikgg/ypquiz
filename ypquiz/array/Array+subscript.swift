//
//  Array+subscript.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 21.10.2025.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
