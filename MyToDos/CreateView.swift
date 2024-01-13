//
//  CreateView.swift
//  MyToDos
//
//  Created by Hoon on 1/12/24.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var item = Item()
    @State private var selectedCategory: Category?

    var body: some View {
        List {
            Section("To do Title") {
                TextField("Name", text: $item.title)
            }

            Section {
                DatePicker("Choose a date",
                           selection: $item.timestamp)
                Toggle("Important?", isOn: $item.isCritical)
            }

            Section {
                Button("Create") {
                    context.insert(item)
                }
            }
        }
        .navigationTitle("Create ToDo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Dismiss")
                }
            }
        }
    }
}

#Preview {
    CreateView()
        .modelContainer(for: Item.self)
}
