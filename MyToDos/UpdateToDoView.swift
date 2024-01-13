//
//  UpdateToDoView.swift
//  MyToDos
//
//  Created by Hoon on 1/13/24.
//

import SwiftData
import SwiftUI

struct UpdateToDoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query private var categories: [Category]
    @State var item: Item
    @State private var selectedCategory: Category?

    var body: some View {
        List {
            Section("To Do title") {
                TextField("Name", text: $item.title)
            }

            Section("General") {
                DatePicker("Choose a date",
                           selection: $item.timestamp)
                Toggle("Important?", isOn: $item.isCritical)
            }

            Section("Select A Category") {
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "archivebox")
                } else {
                    Picker("", selection: $selectedCategory) {
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }

                        Text("None")
                            .tag(nil as Category?)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
            }

            Section {
                Button("Create") {
                    save()
                    dismiss()
                }
            }
        }
        .navigationTitle("Create ToDo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
        }
    }
}

private extension UpdateToDoView {
    func save() {
        modelContext.insert(item)
        item.category = selectedCategory
        selectedCategory?.items?.append(item)
    }
}

// #Preview {
//    UpdateToDoView(item: Item.sef)
// }
