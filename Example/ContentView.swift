//
//  ContentView.swift
//  ValuePickerExample
//
//  Created by Firdavs Khaydarov on 25/01/2025.
//

import SwiftUI
import ValuePicker

struct ContentView: View {
    @State private var revenueSelection: String = "Weekly"
    @State private var displayOptionSelection: DisplayOption = .table
    @State private var colorSelection: ColorItem = .red

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading) {
                Text("Revenue")
                    .font(.title)

                ValuePicker(selection: $revenueSelection) {
                    ForEach(["Weekly", "Monthly", "Quarterly", "Yearly"], id: \.self) { option in
                        Text(option)
                            .valuePickerTag(option)
                    }
                }
            }

            Divider()

            VStack(alignment: .leading) {
                Text("Display Options")
                    .font(.title)

                ValuePicker(selection: $displayOptionSelection) {
                    ForEach(DisplayOption.allCases) { displayOption in
                        Label(displayOption.rawValue, systemImage: displayOption.sfSymbolName)
                            .valuePickerTag(displayOption)
                    }
                }
            }

            Divider()

            VStack(alignment: .leading) {
                Text("Your Favorite Color")
                    .font(.title)

                ValuePicker(selection: $colorSelection) {
                    ForEach(ColorItem.allCases) { c in
                        Circle()
                            .fill(c.color)
                            .frame(width: 12)
                            .padding(6)
                            .valuePickerTag(c)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

enum DisplayOption: String, CaseIterable, Identifiable  {
    case table = "Table"
    case board = "Board"
    case chart = "Chart"

    var id: String { rawValue }

    var sfSymbolName: String {
        switch self {
        case .table: "list.bullet"
        case .board: "square.grid.3x3"
        case .chart: "chart.bar.xaxis"
        }
    }
}

enum ColorItem: String, CaseIterable, Identifiable {
    case red, orange, yellow, green, mint, teal, cyan

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .red: .red
        case .orange: .orange
        case .yellow: .yellow
        case .green: .green
        case .mint: .mint
        case .teal: .teal
        case .cyan: .cyan
        }
    }
}
