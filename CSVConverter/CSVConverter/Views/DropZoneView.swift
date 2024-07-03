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
  @Bindable var viewModel: CSVViewModel
  @Binding var path: NavigationPath
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .stroke(style: StrokeStyle(lineWidth: 3, dash: [3, 3]))
        .foregroundStyle(viewModel.isHovering ? Color.accentColor : Color.secondary)
        .frame(width: 300, height: 200)
      
      VStack {
        Image(systemName: "icloud.and.arrow.down")
          .resizable()
          .scaledToFit()
          .frame(width: 30)
          .foregroundStyle(viewModel.isHovering ? Color.accentColor : Color.secondary)
        Text("Drop CSV file here")
          .foregroundStyle(viewModel.isHovering ? Color.accentColor : Color.secondary)
        
      }
    }
    .onDrop(of: [UTType.fileURL], isTargeted: $viewModel.isHovering) { providers in
      guard let provider = providers.first else { return false }
      
      provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (urlData, error) in
        if let urlData = urlData as? Data {
          let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
          if url.pathExtension.lowercased() == "csv" {
            do {
              print(url.lastPathComponent)
              var tableData = try MLDataTable(contentsOf: url)
              self.viewModel.loadCSV(from: tableData, fileName: url.lastPathComponent)
              self.viewModel.loadCSV(from: url)
              path.append(NavigationViewItem.csvEditorView)
            } catch {
              print(error)
            }
          }
        }
      }
      
      return true
    }
    .navigationDestination(for: NavigationViewItem.self) { view in
      if view == .csvEditorView {
        CSVEditorView(viewModel: viewModel)
      }
    }
  }
}

#Preview("DropZoneView - Normal") {
  DropZoneView(viewModel: CSVViewModel(), path: .constant(NavigationPath()))
}

#Preview("DropZoneView - Hovering") {
  let viewModel = CSVViewModel()
  viewModel.isHovering = true
  return DropZoneView(viewModel: viewModel, path: .constant(NavigationPath()))
}

enum NavigationViewItem: Hashable {
  case dropZone
  case csvEditorView
}
