//
//  Color extinsion.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 24/05/2025.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r, g, b, a: Double
        switch hex.count {
        case 6: 
            r = Double((rgbValue >> 16) & 0xFF) / 255.0
            g = Double((rgbValue >> 8) & 0xFF) / 255.0
            b = Double(rgbValue & 0xFF) / 255.0
            a = 1.0
        case 8:
            r = Double((rgbValue >> 24) & 0xFF) / 255.0
            g = Double((rgbValue >> 16) & 0xFF) / 255.0
            b = Double((rgbValue >> 8) & 0xFF) / 255.0
            a = Double(rgbValue & 0xFF) / 255.0
        default:
            r = 0
            g = 0
            b = 0
            a = 1.0
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
