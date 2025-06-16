//
//  TodoListViewModel.swift
//  TodoList
//
//  Created by Milos Taskovic on 16. 6. 2025..
//
import SwiftUI

@Observable
final class TodoListViewModel {
    enum Filter { case all, active, completed }

    var todos: [TodoItem] = []
    var filter: Filter = .all
    var showAddAlert = false
    var alertText = ""
    
    var filteredTodos: [TodoItem] {
        switch filter {
        case .all: return todos
        case .active: return todos.filter { !$0.isCompleted }
        case .completed: return todos.filter { $0.isCompleted }
        }
    }

    func add(title: String) {
        todos.append(.init(id: UUID(), title: title, isCompleted: false))
    }

    func toggle(item: TodoItem) {
        guard let index = todos.firstIndex(where: { $0 == item }) else { return }
        todos[index].isCompleted.toggle()
    }

    func setFilter(_ f: Filter) {
        filter = f
    }
    
    func addTodoButtonTapped() {
        showAddAlert = true
        alertText = ""
    }
    
    func createTodoButtonTapped() {
        let trimmed = alertText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            add(title: trimmed)
        }
        alertText = ""
    }
}
