//
//  DropZoneView.swift
//  CSVConverter
//
//  Created by Gyunni on 7/2/24.
//

import SwiftUI
import UniformTypeIdentifiers
import CreateML

struct DropZoneView: View {
  var tableManager: CSVTableManager
  @Bindable var viewModel: CSVViewModel
  @Binding var path: NavigationPath
  
  @State private var isHovering = false
  
  var body: some View {
    ZStack {
      dropZone
      
      guidingContent
    }
    .onDrop(of: [UTType.fileURL], isTargeted: $isHovering) { providers in
      guard let provider = providers.first else { return false }
      
      loadData(from: provider)
      
      return true
    }
    .padding(50)
    .navigationDestination(for: NavigationViewItem.self) { view in
      if view == .csvEditorView {
        CSVEditorView(viewModel: viewModel)
      }
    }
  }
}

// MARK: View Components
extension DropZoneView {
  private var dropZone: some View {
    RoundedRectangle(cornerRadius: 10)
      .stroke(style: StrokeStyle(lineWidth: 3, dash: [3, 3]))
      .foregroundStyle(isHovering ? Color.accentColor : Color.secondary)
      .frame(width: 300, height: 200)
  }
  
  private var guidingContent: some View {
    VStack {
      Image(systemName: "icloud.and.arrow.down")
        .resizable()
        .scaledToFit()
        .frame(width: 30)
        .foregroundStyle(isHovering ? Color.accentColor : Color.secondary)
      Text("Drop CSV file here")
        .foregroundStyle(isHovering ? Color.accentColor : Color.secondary)
    }
  }
}

// MARK: Functions
extension DropZoneView {
  func loadData(from provider: NSItemProvider) {
    provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (urlData, error) in
      if let urlData = urlData as? Data {
        let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
        if url.pathExtension.lowercased() == "csv" {
          do {
            print(url.lastPathComponent)
            let tableData = try MLDataTable(contentsOf: url)
            self.tableManager.dataTable = tableData
            self.viewModel.loadCSV(from: tableData, fileName: url.lastPathComponent)
            self.viewModel.loadCSV(from: url)
            path.append(NavigationViewItem.csvEditorView)
          } catch {
            print(error)
          }
        }
      }
    }
  }
}

// MARK: Previews
#Preview("DropZoneView - Normal") {
  DropZoneView(tableManager: CSVTableManager(), viewModel: CSVViewModel(), path: .constant(NavigationPath()))
}

#Preview("DropZoneView - Hovering") {
  let viewModel = CSVViewModel()
  viewModel.isHovering = true
  return DropZoneView(tableManager: CSVTableManager(), viewModel: viewModel, path: .constant(NavigationPath()))
}
