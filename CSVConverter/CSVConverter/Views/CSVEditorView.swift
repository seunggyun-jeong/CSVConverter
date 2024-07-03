//
//  CSVEditorView.swift
//  CSVConverter
//
//  Created by Gyunni on 7/2/24.
//

import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct CSVEditorView: View {
  @Bindable var viewModel: CSVViewModel
  
  var body: some View {
    VStack {
      if !viewModel.csvData.rows.isEmpty {
        ScrollView {
          VStack(alignment: .leading, spacing: 10) {
            // 제목 행 표시
            HStack {
              ForEach(viewModel.csvData.headers, id: \.self) { header in
                Text(header)
                  .font(.headline)
                  .frame(maxWidth: .infinity)
              }
            }
            .padding(.bottom)
            
            // 데이터 행 표시
            ForEach(Array(viewModel.csvData.rows.enumerated()), id: \.element.id) { rowIndex, row in
              HStack {
                ForEach(Array(row.data.enumerated()), id: \.offset) { columnIndex, _ in
                  TextField("", text: $viewModel.csvData.rows[rowIndex].data[columnIndex])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                }
              }
            }
          }
          .padding()
        }
      } else {
        Text("No CSV data loaded")
      }
    }
    .frame(minWidth: 600, minHeight: 400)
    .navigationTitle(viewModel.csvData.fileName)
    .onDisappear {
      viewModel.csvData = CSVData(fileName: "", headers: [], rows: [])
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button {
          saveCSV()
        } label: {
          Image(systemName: "square.and.arrow.down")
        }
      }
      
      ToolbarItem(placement: .confirmationAction) {
        Button {
          saveToMD()
        } label: {
          Text("MD로 저장")
        }
      }
    }
  }
  
  private func saveCSV() {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [UTType.commaSeparatedText]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = "Save CSV File"
    savePanel.message = "Choose a location to save the CSV file"
    savePanel.nameFieldStringValue = "exported.csv"
    
    let response = savePanel.runModal()
    
    if response == .OK, let url = savePanel.url {
      viewModel.saveCSV(to: url)
    }
  }
  
  private func saveToMD() {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [UTType.markdown]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = "Save MD File"
    savePanel.message = "Choose a location to save the MD file"
    savePanel.nameFieldStringValue = "exported.md"
    
    let response = savePanel.runModal()
    
    if response == .OK, let url = savePanel.url {
      print(url)
      viewModel.saveToMD(to: url)
    }
  }
}

#Preview("CSVEditorView - With Data") {
  let viewModel = CSVViewModel()
  viewModel.csvData = CSVData(
    fileName: "NewFile", headers: ["Name", "Age", "City"],
    rows: [
      CSVRow(data: ["John Doe", "30", "New York"]),
      CSVRow(data: ["Jane Smith", "28", "San Francisco"]),
      CSVRow(data: ["Bob Johnson", "45", "Chicago"])
    ]
  )
  return CSVEditorView(viewModel: viewModel)
}

#Preview("CSVEditorView - Empty") {
  CSVEditorView(viewModel: CSVViewModel())
}
