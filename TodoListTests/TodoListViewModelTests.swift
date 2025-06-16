//
//  TodoListViewModelTests.swift
//  TodoListTests
//
//  Created by Milos Taskovic on 16. 6. 2025..
//

import XCTest
@testable import TodoList

final class TodoListViewModelTests: XCTestCase {
    func testAddTodo() {
        let vm = TodoListViewModel()
        vm.add(title: "Buy milk")
        XCTAssertEqual(vm.todos.count, 1)
        XCTAssertEqual(vm.todos.first?.title, "Buy milk")
    }

    func testToggleTodo() {
        let vm = TodoListViewModel()
        vm.add(title: "Read")
        let itemToToggle = vm.todos[0]
        vm.toggle(item: itemToToggle)
        XCTAssertTrue(vm.todos[0].isCompleted)
    }

    func testFilterCompleted() {
        let vm = TodoListViewModel()
        vm.add(title: "One")
        vm.add(title: "Two")
        vm.toggle(item: vm.todos[0])
        vm.setFilter(.completed)
        XCTAssertEqual(vm.filteredTodos.count, 1)
        XCTAssertTrue(vm.filteredTodos[0].isCompleted)
    }
    
    func testSetFilter() {
        let vm = TodoListViewModel()
        vm.setFilter(.active)
        XCTAssertEqual(vm.filter, .active)
    }

    func testAddTodoButtonTapped() {
        let vm = TodoListViewModel()
        vm.addTodoButtonTapped()
        XCTAssertTrue(vm.showAddAlert)
        XCTAssertEqual(vm.alertText, "")
    }

    func testCreateTodoButtonTappedWithValidText() {
        let vm = TodoListViewModel()
        vm.alertText = "New Task"
        vm.createTodoButtonTapped()
        XCTAssertEqual(vm.todos.count, 1)
        XCTAssertEqual(vm.todos.first?.title, "New Task")
        XCTAssertEqual(vm.alertText, "")
    }

    func testCreateTodoButtonTappedWithEmptyText() {
        let vm = TodoListViewModel()
        vm.alertText = "   "
        vm.createTodoButtonTapped()
        XCTAssertEqual(vm.todos.count, 0)
        XCTAssertEqual(vm.alertText, "")
    }
    
    func testToggleNonExistentTodo() {
        // Arrange
        let vm = TodoListViewModel()
        vm.add(title: "Task A")
        let nonExistentItem = TodoItem(id: UUID(), title: "Task B", isCompleted: false)

        // Act
        vm.toggle(item: nonExistentItem)

        // Assert
        XCTAssertEqual(vm.todos.count, 1, "The number of todos should remain unchanged.")
        XCTAssertFalse(vm.todos[0].isCompleted, "The existing todo should remain unmodified.")
    }
    
    func testFilterActiveItems() {
        // Arrange
        let vm = TodoListViewModel()
        vm.add(title: "Task 1")
        vm.add(title: "Task 2")
        vm.toggle(item: vm.todos[0]) // Mark "Task 1" as completed

        // Act
        vm.setFilter(.active)

        // Assert
        XCTAssertEqual(vm.filteredTodos.count, 1, "Only active items should be filtered.")
        XCTAssertEqual(vm.filteredTodos[0].title, "Task 2", "The active item should be 'Task 2'.")
        XCTAssertFalse(vm.filteredTodos[0].isCompleted, "Filtered items should not be completed.")
    }
}
