//
//  CSVViewModel.swift
//  CSVConverter
//
//  Created by Gyunni on 7/2/24.
//

import SwiftUI
import UniformTypeIdentifiers

@Observable
class CSVViewModel {
  var csvData = CSVData(headers: [], rows: [])
  var isHovering = false
  
  func loadCSV(from url: URL) {
    do {
      let content = try String(contentsOf: url)
      let rows = parseCSV(content)
      
      if !rows.isEmpty {
        let headers = rows[0]
        let dataRows = rows.dropFirst().map { CSVRow(data: $0) }
        csvData = CSVData(headers: headers, rows: dataRows)
      } else {
        csvData = CSVData(headers: [], rows: [])
      }
    } catch {
      print("Error reading CSV file: \(error)")
    }
  }
  
  
  private func parseCSV(_ string: String) -> [[String]] {
    var result: [[String]] = []
    var currentRow: [String] = []
    var currentField = ""
    var insideQuotes = false
    
    for character in string {
      switch character {
      case "\"":
        insideQuotes.toggle()
      case ",":
        if insideQuotes {
          currentField.append(character)
        } else {
          currentRow.append(currentField)
          currentField = ""
        }
      case "\n", "\r\n":
        if insideQuotes {
          currentField.append(character)
        } else {
          if !currentField.isEmpty {
            currentRow.append(currentField)
          }
          if !currentRow.isEmpty {
            result.append(currentRow)
          }
          currentRow = []
          currentField = ""
        }
      default:
        currentField.append(character)
      }
    }
    
    // 마지막 필드와 행 처리
    if !currentField.isEmpty {
      currentRow.append(currentField)
    }
    if !currentRow.isEmpty {
      result.append(currentRow)
    }
    
    return result
  }
  
  func saveCSV(to url: URL) {
    do {
      var csvString = csvData.headers.joined(separator: ",") + "\n"
      csvString += csvData.rows.map { row in
        row.data.map { field in
          if field.contains(",") || field.contains("\"") {
            return "\"\(field.replacingOccurrences(of: "\"", with: "\"\""))\""
          } else {
            return field
          }
        }.joined(separator: ",")
      }.joined(separator: "\n")
      try csvString.write(to: url, atomically: true, encoding: .utf8)
      print("CSV file saved successfully")
    } catch {
      print("Error saving CSV file: \(error)")
    }
  }
}
