//
//  FilterYearsSettings.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 06.04.2024.
//

import Foundation

struct FilterYearsSettings {
    
    func parseURL(url: String) -> String? {
        let urlParts = url.components(separatedBy: "/")
        let last = urlParts.last
        let year = last?.components(separatedBy: ".")[0]
        return year
    }
}
