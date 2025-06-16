//
//  TodoItem.swift
//  TodoList
//
//  Created by Milos Taskovic on 16. 6. 2025..
//
import Foundation

struct TodoItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}
