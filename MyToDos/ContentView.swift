//
//  ContentView.swift
//  MyToDos
//
//  Created by Hoon on 1/12/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var context

    @State private var showCreate = false
    @State private var toDoToEdit: Item?
    @Query private var items: [Item]

    @State private var showCategory = false

    @State private var searchQuery: String = ""

    var filteredItems: [Item] {
        if searchQuery.isEmpty {
            return items
        }

        let filteredItems = items.compactMap { item in
            let titleContainsQuery = item.title.range(
                of: searchQuery,
                options: .caseInsensitive
            ) != nil

            let categoryTitleContainsQuery = item.category?.title.range(
                of: searchQuery,
                options: .caseInsensitive
            ) != nil

            return (titleContainsQuery || categoryTitleContainsQuery) ? item : nil
        }

        return filteredItems
    }

    var body: some View {
        NavigationStack {
            List {
                if items.isEmpty {
                    ContentUnavailableView("No ToDo", systemImage: "archivebox")
                } else {
                    ForEach(filteredItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                if item.isCritical {
                                    Image(systemName: "exclamationmark.3")
                                        .symbolVariant(.fill)
                                        .foregroundColor(.red)
                                        .font(.largeTitle)
                                        .bold()
                                }

                                Text(item.title)
                                    .font(.largeTitle)
                                    .bold()

                                Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                    .font(.callout)

                                if let category = item.category {
                                    TagText(title: category.title)
                                }
                            }

                            Spacer()

                            Button {
                                withAnimation {
                                    item.isCompleted.toggle()
                                }
                            } label: {
                                Image(systemName: "checkmark")
                                    .symbolVariant(.circle.fill)
                                    .foregroundColor(item.isCompleted ? .green : .gray)
                                    .font(.largeTitle)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    context.delete(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .symbolVariant(/*@START_MENU_TOKEN@*/ .fill/*@END_MENU_TOKEN@*/)
                            }
                            Button {
                                toDoToEdit = item
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle("My To Do List")
            .searchable(text: $searchQuery,
                        prompt: "Search for a title or a category")
            .overlay {
                if filteredItems.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showCreate.toggle()
                    }, label: {
//                        Label("Add Item", systemImage: "plus")
                        Text("Add Item")
                    })
                }

                ToolbarItem {
                    Button(action: {
                        showCategory.toggle()
                    }, label: {
                        Text("Add Category")
                    })
                }
            }
            .sheet(isPresented: $showCreate, content: {
                NavigationStack {
                    UpdateToDoView(item: Item())
                }
                .presentationDetents([.large])
//                UpdateToDoView(item: Item())
            })
            .sheet(item: $toDoToEdit) {
                toDoToEdit = nil
            } content: { item in
                NavigationStack {
                    UpdateToDoView(item: item)
                }
            }
            .sheet(isPresented: $showCategory, content: {
                NavigationStack {
                    CreateCategoryView()
                }
            })
        }
    }
}

#Preview {
    ContentView()
}

struct TagText: View {
    var title: String

    var body: some View {
        Text(title)
            .foregroundStyle(Color.blue)
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(
                Color.blue.opacity(0.1),
                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
            )
    }
}
