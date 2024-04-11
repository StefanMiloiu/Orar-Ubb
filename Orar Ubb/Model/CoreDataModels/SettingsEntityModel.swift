//
//  SettingsEntityModel.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 08.04.2024.
//

import Foundation

extension SettingEntity: Model{
    
    func toString() -> String {
        return "Link \(section ?? "NIL SECTION") \n Group \(group ?? "NIL GROUP") \n Subgroup \(semiGroup ?? "NIL SUBGROUP") \n )"
    }
}

extension Lecture: Model{
}

