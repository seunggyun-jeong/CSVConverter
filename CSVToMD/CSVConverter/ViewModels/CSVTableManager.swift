//
//  CSVTableManager.swift
//  CSVConverter
//
//  Created by Gyunni on 7/5/24.
//

import CreateML
import SwiftUI

@Observable
final class CSVTableManager {
  var dataTable: MLDataTable?
  
  func getAllColumns() -> [String] {
    guard let headers = dataTable?.columnNames.map({ $0 as String }) else { return [] }
    return headers
  }
}
