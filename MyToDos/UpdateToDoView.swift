//
//  UpdateToDoView.swift
//  MyToDos
//
//  Created by Hoon on 1/13/24.
//

import SwiftUI

struct UpdateToDoView: View {
    @Environment(\.dismiss) var dismiss

    @Bindable var item: ToDoItem

    var body: some View {
        List {
            TextField("Name", text: $item.title)
            DatePicker("Choose a date",
                       selection: $item.timestamp)
            Toggle("Important?", isOn: $item.isCritical)
            Button("Update") {
                dismiss()
            }
        }
    }
}

// #Preview {
//    UpdateToDoView()
//        .modelContext(for: ToDoItem)
// }
