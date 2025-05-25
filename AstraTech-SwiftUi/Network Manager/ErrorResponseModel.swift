//
//  ErrorResponseModel.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 24/05/2025.
//

import Foundation

struct ErrorResponse: Codable {
    let message: String
    let errors: [String: [String]]
}

