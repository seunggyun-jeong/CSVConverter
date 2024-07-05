//
//  ContentView.swift
//  CSVConverter
//
//  Created by Gyunni on 7/1/24.
//

import SwiftUI

struct ContentView: View {
  @State private var viewModel = CSVViewModel()
  @State private var tableManager = CSVTableManager()
  @Binding var path: NavigationPath
  
  var body: some View {
    NavigationSplitView {
      FileListView()
    } content: {
      NavigationStack(path: $path) {
        DropZoneView(tableManager: tableManager, viewModel: viewModel, path: $path)
          .navigationTitle("CSV To MarkDown")
      }
    } detail: {
      if !viewModel.csvData.fileName.isEmpty {
        ToolBoxView()
          .navigationSplitViewColumnWidth(min: 50, ideal: 300, max: 500)
      }
    }
  }
}

#Preview("ContentView - Empty") {
  ContentView(path: .constant(NavigationPath()))
}

#Preview("ContentView - With Data") {
  let viewModel = CSVViewModel()
  viewModel.csvData = CSVData(
    fileName: "NewFile", headers: ["Name", "Age", "City"],
    rows: [
      CSVRow(data: ["John Doe", "30", "New York"]),
      CSVRow(data: ["Jane Smith", "28", "San Francisco"]),
      CSVRow(data: ["Bob Johnson", "45", "Chicago"])
    ]
  )
  return ContentView(viewModel: viewModel, path: .constant(NavigationPath()))
}

extension ContentView {
  init(viewModel: CSVViewModel, path: Binding<NavigationPath>) {
    _viewModel = State(wrappedValue: viewModel)
    _path = path
  }
}
