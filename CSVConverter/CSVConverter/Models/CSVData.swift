//
//  CSVData.swift
//  CSVConverter
//
//  Created by Gyunni on 7/2/24.
//

import Foundation

struct CSVData {
  var headers: [String]
  var rows: [CSVRow]
}

struct CSVRow: Identifiable {
  let id = UUID()
  var data: [String]
}
