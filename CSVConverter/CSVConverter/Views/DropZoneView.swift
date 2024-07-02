//
//  DropZoneView.swift
//  CSVConverter
//
//  Created by Gyunni on 7/2/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DropZoneView: View {
  @Bindable var viewModel: CSVViewModel
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .fill(viewModel.isHovering ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
        .frame(width: 300, height: 200)
      
      Text("Drop CSV file here")
        .foregroundColor(.primary)
    }
    .onDrop(of: [UTType.fileURL], isTargeted: $viewModel.isHovering) { providers in
      guard let provider = providers.first else { return false }
      
      provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (urlData, error) in
        if let urlData = urlData as? Data {
          let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
          if url.pathExtension.lowercased() == "csv" {
            self.viewModel.loadCSV(from: url)
          }
        }
      }
      
      return true
    }
  }
}

#Preview("DropZoneView - Normal") {
  DropZoneView(viewModel: CSVViewModel())
}

#Preview("DropZoneView - Hovering") {
  let viewModel = CSVViewModel()
  viewModel.isHovering = true
  return DropZoneView(viewModel: viewModel)
}
