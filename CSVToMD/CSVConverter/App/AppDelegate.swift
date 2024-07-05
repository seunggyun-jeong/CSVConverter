//
//  AppDelegate.swift
//  CSVConverter
//
//  Created by Gyunni on 7/3/24.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    if let window = NSApplication.shared.windows.first {
      window.delegate = self
    }
  }
  
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    NSApplication.shared.terminate(self)
    return true
  }
}
