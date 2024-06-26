//
//  LecturesViewModel.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 10.04.2024.
//

import Foundation
import SwiftUI

class SharedLecturesViewModel: ObservableObject {
    @Published var lectures: [Lecture] = []
    @Published var disciplines: [DisciplineFilter] = []
}

class SharedTintColorViewModel: ObservableObject{
    @Published var tintColor: Color = .red.opacity(0.7)
}
