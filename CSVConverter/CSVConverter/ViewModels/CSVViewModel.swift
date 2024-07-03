//
//  CSVViewModel.swift
//  CSVConverter
//
//  Created by Gyunni on 7/2/24.
//

import SwiftUI
import UniformTypeIdentifiers
import CreateML

@Observable
class CSVViewModel {
  var csvData = CSVData(fileName: "", headers: [], rows: [])
  var tableData = TableData(fileName: "", headers: [], data: [])
  var isHovering = false
  
  func loadCSV(from url: URL) {
    do {
      let content = try String(contentsOf: url)
      print(content)
      let rows = parseCSV(content)
      
      if !rows.isEmpty {
        let headers = rows[0]
        let dataRows = rows.dropFirst().map { CSVRow(data: $0) }
        csvData = CSVData(fileName: url.lastPathComponent, headers: headers, rows: dataRows)
      } else {
        csvData = CSVData(fileName: "", headers: [], rows: [])
      }
    } catch {
      print("Error reading CSV file: \(error)")
    }
  }
  
  func loadCSV(from table: MLDataTable, fileName: String) {
    print(table)
    self.tableData = TableData(table: table, fileName: fileName)
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
  
  func saveToMD(to url: URL) {
    do {
      var mdString = ""
      tableData.data.forEach { row in
        var resultString = 
                          """
                          #### Pair \(row[GitHubArchiveColumn.teamNumber.rawValue]?.intValue ?? 0) | \(row[GitHubArchiveColumn.teamName.rawValue]?.stringValue ?? "")
                          > \(row[GitHubArchiveColumn.appStatement.rawValue]?.stringValue ?? "")
                          - \(row[GitHubArchiveColumn.topic.rawValue]?.stringValue ?? "")
                          - [🔗 Repository](\(row[GitHubArchiveColumn.url.rawValue]?.stringValue ?? ""))
                          - Member : \(row[GitHubArchiveColumn.members.rawValue]?.stringValue ?? "")\n\n
                          """
        mdString += resultString
      }
      
      try mdString.write(to: url, atomically: true, encoding: .utf8)
    } catch {
      print(error)
    }
  }
}

enum GitHubArchiveColumn: String {
  case teamNumber = "팀 번호"
  case teamName = "팀 이름"
  case members = "Members"
  case appStatement = "App statement"
  case url = "Repository URL"
  case topic = "주요 기술"
}
