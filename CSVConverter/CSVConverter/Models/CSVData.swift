//
//  CSVData.swift
//  CSVConverter
//
//  Created by Gyunni on 7/2/24.
//

import Foundation
import CreateML

struct CSVData {
  var fileName: String
  var headers: [String]
  var rows: [CSVRow]
  
  // TODO: CreateML의 MLDataTable을 이용하여 더 효율적인 방법 생각하기
}

struct TableData {
  var fileName: String
  var headers: [String]
  var data: [MLDataTable.Rows.Element]
  
  init(fileName: String, headers: [String], data: [MLDataTable.Rows.Element]) {
    self.fileName = fileName
    self.headers = headers
    self.data = data
  }
  
  init(table: MLDataTable, fileName: String) {
    print(table.rows.map { $0 })
    self.fileName = fileName
    self.headers = table.columnNames.map { $0 }
    self.data = table.rows.map { $0 }
  }
}

struct CSVRow: Identifiable {
  let id = UUID()
  var data: [String]
}
