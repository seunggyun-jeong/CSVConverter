//
//  TableTestView.swift
//  CSVConverter
//
//  Created by Gyunni on 7/4/24.
//

import SwiftUI
import CreateML

struct TableTestView: View {
  var body: some View {
    Text("MLTable 테스트")
      .onAppear {
        do {
          try tableTest()
        } catch {
          print("error: \(error)")
        }
      }
  }
  
  private func tableTest() throws {
    let fileManager = FileManager.default
    guard let documentDirectory = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first else { return }
    let fileURL = documentDirectory.appending(path: "testData.csv")
    
    // DataTable
    let tableData = try MLDataTable(contentsOf: fileURL)
    print("------ DataTable")
    print(tableData)
    
    // columnNames : MLDataTable.columnNames
    let headers = tableData.columnNames
    print("------ columnNames")
    print(headers)
    
    // Type Casting, MLDataTable.columnNames to String
    let stringHeaders = headers.map { $0 as String }
    print("------ stringHeaders")
    print(stringHeaders)
    
    // Header Type : [String : MLDataValue.ValueType]
    let headerType = tableData.columnTypes
    print("------ Header Type")
    print(headerType)
    
    let rows = tableData.rows
    print("------ rows")
    print(rows)
    
    var table = TestTable(dataTable: tableData)
    
    // Test Table
    print("------ testTable.header")
    print(table.headers)
    print("------ testTable.rows")
    print(table.rows)
    
    // Value 불러오기
    print("------ testTable Value")
    print(table.rows.first!.row[table.headers.keys.first!]!.getProperty())
  }
}

#Preview {
  TableTestView()
}

/// 데이터를 쉽게 다루려면 String 형태로 만드는 것이 좋음
struct TestTable {
  var headers: [String: MLDataValue.ValueType]
  var rows: [TestTableRow]
  
  init(dataTable: MLDataTable) {
    self.headers = dataTable.columnTypes
    self.rows = dataTable.rows.map { row in
      TestTableRow(row: row)
    }
  }
}

struct TestTableRow {
  var row: [String: TestTableValue]
  
  init(row: MLDataTable.Rows.Element) {
    var result: [String : TestTableValue] = [:]
    row.forEach { key, value in
      result[key] = TestTableValue(type: key.dataValue.type, value: value)
    }
    
    self.row = result
  }
}

struct TestTableValue {
  var type: MLDataValue.ValueType
  var value: MLDataValue
  
  func getProperty() -> String {
    switch type {
    case .int:
      guard let unwrappedValued = value.intValue else { return "" }
      return "\(unwrappedValued)"
    case .double:
      guard let unwrappedValued = value.doubleValue else { return "" }
      return "\(unwrappedValued)"
    case .string:
      return "\(value.stringValue ?? "")"
    case .sequence:
      return "value.sequenceValue"
    case .dictionary:
      return "value.dictionaryValue"
    case .multiArray:
      return "value.multiArrayValue"
    case .invalid:
      return ""
    @unknown default:
      return ""
    }
  }
}
