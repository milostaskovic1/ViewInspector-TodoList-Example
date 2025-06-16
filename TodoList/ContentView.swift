//
//  ContentView.swift
//  TodoList
//
//  Created by Milos Taskovic on 16. 6. 2025..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TodoListView(viewModel: TodoListViewModel())
        }
    }
}

#Preview {
    ContentView()
}
