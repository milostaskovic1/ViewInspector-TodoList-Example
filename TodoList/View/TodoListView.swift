//
//  TodoListView.swift
//  TodoList
//
//  Created by Milos Taskovic on 16. 6. 2025..
//

import SwiftUI

struct TodoListView: View {
    @State var viewModel: TodoListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $viewModel.filter) {
                    Text("All").tag(TodoListViewModel.Filter.all)
                    Text("Active").tag(TodoListViewModel.Filter.active)
                    Text("Completed").tag(TodoListViewModel.Filter.completed)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List(viewModel.filteredTodos) { todo in
                    HStack {
                        Text(todo.title).strikethrough(todo.isCompleted)
                        Spacer()
                        Button(action: { viewModel.toggle(item: todo) } ) {
                            Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                        }
                    }
                }
            }
        }
        .navigationTitle("Todo List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.addTodoButtonTapped) {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("New Task", isPresented: $viewModel.showAddAlert) {
            TextField("Task title", text: $viewModel.alertText)
            Button("Create", action: viewModel.createTodoButtonTapped)
            Button("Cancel", role: .cancel) {}
        }
    }
}
