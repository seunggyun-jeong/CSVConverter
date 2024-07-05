//
//  CSVConverterApp.swift
//  CSVConverter
//
//  Created by Gyunni on 7/1/24.
//

import SwiftUI

@main
struct CSVConverterApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @State private var path = NavigationPath()
  
  var body: some Scene {
    WindowGroup {
      ContentView(path: $path)
    }
    .commands {
      CommandGroup(after: .newItem) {
        Button("Go Back") {
          path.removeLast()
        }
        .keyboardShortcut("B", modifiers: .command)
        .disabled(path.isEmpty)
      }
    }
  }
}

@Observable
class AppState {
    var isEditing = false
    var canGoBack = false

    func goBack() {
        if isEditing {
            isEditing = false
            canGoBack = false
        }
    }
}
