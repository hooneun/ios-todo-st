//
//  CreateCategoryView.swift
//  MyToDos
//
//  Created by Hoon on 1/13/24.
//

import SwiftData
import SwiftUI

@Model
class Category {
    @Attribute(.unique)
    var title: String

    var items: [Item]?

    init(title: String = "") {
        self.title = title
    }
}

struct CreateCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @Query private var categories: [Category]

    var body: some View {
        List {
            Section("Category Title") {
                TextField("Enter title here", text: $title)
                Button("Add Category") {
                    withAnimation {
                        let category = Category(title: title)
                        modelContext.insert(category)
                        category.items = []
                        title = ""
                    }
                }
                .disabled(title.isEmpty)
            }

            Section("Categories") {
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "archivebox")
                } else {
                    ForEach(categories) { category in
                        Text(category.title)
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(category)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Add Category")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    CreateCategoryView()
}
