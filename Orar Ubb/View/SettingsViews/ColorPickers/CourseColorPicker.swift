//
//  CourseColorPicker.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 15.04.2024.
//

import SwiftUI

struct ColorPickersView: View {
    var body: some View {
        VStack {
            CourseColorPicker()
            SeminarColorPicker()
            LabColorPicker()
        }
    }
}

struct CourseColorPicker: View {
    @State var viewModel = CourseColorPickersViewModel()
    @State var selectedColorCours: Color = .gray
    
    var body: some View {
        ColorPicker("Course", selection: $selectedColorCours)
            .onChange(of: selectedColorCours) {
                viewModel.updateColor(courseType: "Curs", color: selectedColorCours)
            }
            .onAppear {
                let color = viewModel.getColor(courseType: "Curs")
                selectedColorCours = Color(.sRGB, red: color.components.r, green: color.components.g, blue: color.components.b, opacity: color.components.a)
            }
    }
}

struct SeminarColorPicker: View {
    @State var viewModel = CourseColorPickersViewModel()
    @State var selectedColorSeminar: Color = .red
    var body: some View {
        ColorPicker("Seminar", selection: $selectedColorSeminar)
            .onChange(of: selectedColorSeminar) {
                viewModel.updateColor(courseType: "Seminar", color: selectedColorSeminar)
            }
            .onAppear {
                let color = viewModel.getColor(courseType: "Seminar")
                selectedColorSeminar = Color(.sRGB, red: color.components.r, green: color.components.g, blue: color.components.b, opacity: color.components.a)
            }
    }
}

struct LabColorPicker: View {
    @State var viewModel = CourseColorPickersViewModel()
    @State var selectedColorLab: Color = .red
    var body: some View {
        ZStack{
            ColorPicker("Lab", selection: $selectedColorLab)
                .onChange(of: selectedColorLab) {
                    viewModel.updateColor(courseType: "Laborator", color: selectedColorLab)
                }
        }
        .onAppear {
            let color = viewModel.getColor(courseType: "Laborator")
            selectedColorLab = Color(.sRGB, red: color.components.r, green: color.components.g, blue: color.components.b, opacity: color.components.a)
//            if color != .black{
//                selectedColorLab = Color(.sRGB, red: color.components.r, green: color.components.g, blue: color.components.b, opacity: color.components.a)
//            } else {
//                selectedColorLab = .gray
//            }
        }
    }
}


#Preview {
    ColorPickersView()
}
