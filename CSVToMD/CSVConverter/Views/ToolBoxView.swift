//
//  ToolBoxView.swift
//  CSVConverter
//
//  Created by Gyunni on 7/5/24.
//

import SwiftUI

struct ToolBoxView: View {
  var body: some View {
    List {
      ForEach(1..<30) { num in
        HStack {
          Text("file.name")
        }
      }
    }
  }
}

#Preview {
  ToolBoxView()
}
