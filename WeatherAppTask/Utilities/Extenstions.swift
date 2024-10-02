//
//  Extenstions.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import Foundation

extension Int {
    func convertToFormat() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "E, dd MMM yyyy, HH:mm a"
        return dateFormatter.string(from: date)
    }
}
