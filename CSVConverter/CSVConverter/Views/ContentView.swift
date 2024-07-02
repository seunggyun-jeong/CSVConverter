//
//  ContentView.swift
//  CSVConverter
//
//  Created by Gyunni on 7/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = CSVViewModel()

    var body: some View {
        VStack {
            if viewModel.csvData.rows.isEmpty {
                DropZoneView(viewModel: viewModel)
            } else {
                CSVEditorView(viewModel: viewModel)
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

#Preview("ContentView - Empty") {
    ContentView()
}

#Preview("ContentView - With Data") {
    let viewModel = CSVViewModel()
    viewModel.csvData = CSVData(
        headers: ["Name", "Age", "City"],
        rows: [
            CSVRow(data: ["John Doe", "30", "New York"]),
            CSVRow(data: ["Jane Smith", "28", "San Francisco"]),
            CSVRow(data: ["Bob Johnson", "45", "Chicago"])
        ]
    )
    return ContentView(viewModel: viewModel)
}

extension ContentView {
    init(viewModel: CSVViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
}
