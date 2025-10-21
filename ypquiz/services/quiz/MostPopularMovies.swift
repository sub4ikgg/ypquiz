//
//  MostPopularMovies.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 19.10.2025.
//

import Foundation

struct MostPopularMovies: Decodable {
    let errorMessage: String
    let items: [MostPopularMovie]
}
