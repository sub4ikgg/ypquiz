//
//  NetworkClientProtocol.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 21.10.2025.
//

import Foundation

protocol NetworkClientProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
