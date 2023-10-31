//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Ринат Шарафутдинов on 31.10.2023.
//

import Foundation

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let formatterDate = ISO8601DateFormatter()
}

