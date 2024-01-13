//
//  MyToDosApp.swift
//  MyToDos
//
//  Created by Hoon on 1/12/24.
//

import SwiftData
import SwiftUI

@main
struct MyToDosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ToDoItem.self)
        }
    }
}
