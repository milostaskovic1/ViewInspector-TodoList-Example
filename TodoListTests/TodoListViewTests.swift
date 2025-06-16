//
//  TodoListViewTests.swift
//  TodoList
//
//  Created by Milos Taskovic on 16. 6. 2025..
//
import XCTest
import ViewInspector
@testable import TodoList

final class TodoListViewTests: XCTestCase {
    
    func testListRendersCorrectRows() throws {
        // Arrange
        let vm = TodoListViewModel()
        vm.add(title: "Task A")
        vm.add(title: "Task B")
        // Act
        let view = TodoListView(viewModel: vm)
        
        // Assert
        let list = try view.inspect().navigationStack().vStack().list(1)
        let rows = list.findAll(ViewType.HStack.self)
        
        // Assert that we have the expected number of rows
        XCTAssertEqual(rows.count, 2)

        let firstRow = rows[0]
        XCTAssertEqual(try firstRow.text(0).string(), "Task A")
        XCTAssertNoThrow(try firstRow.spacer(1))
        XCTAssertEqual(try firstRow.button(2).labelView().image().actualImage().name(), "square")

        
        let secondRow = rows[1]
        XCTAssertEqual(try secondRow.text(0).string(), "Task B")
        XCTAssertNoThrow(try secondRow.spacer(1))
        XCTAssertEqual(try secondRow.button(2).labelView().image().actualImage().name(), "square")
    }

    func testStrikethroughAndCheckmarSetWhenInitWithCompletedTask() throws {
        // Arrange
        let vm = TodoListViewModel()
        vm.add(title: "Do it")
        let itemToToggle = vm.todos[0]
        vm.toggle(item: itemToToggle)
        
        // Act
        let view = TodoListView(viewModel: vm)
        
        // Assert
        let list = try view.inspect().navigationStack().vStack().list(1)
        let rows = list.findAll(ViewType.HStack.self)
        let firstRow = rows[0]
        let textView = try firstRow.text(0)
        XCTAssertTrue(try textView.attributes().isStrikethrough())
        
        XCTAssertNoThrow(try firstRow.spacer(1))
        
        let image = try firstRow.button(2).labelView().image().actualImage().name()
        XCTAssertEqual(image, "checkmark.square")
    }
    
    func testViewShowsAlertWhenAddTodoButtonTapped() throws {
        // Arrange
        let vm = TodoListViewModel()
        vm.addTodoButtonTapped()
        let view = TodoListView(viewModel: vm)

        let alert = try view.inspect().navigationStack().alert()
        
        // After tapping, the alert should be presented
        XCTAssertEqual(try alert.title().string(), "New Task")
        XCTAssertNoThrow(try alert.find(button: "Create"))
        XCTAssertNoThrow(try alert.find(button: "Cancel"))
    }
    
    func testAlertCancelButtonTappedCanBeTapped() throws {
        // Arrange
        let vm = TodoListViewModel()
        vm.addTodoButtonTapped()
        let view = TodoListView(viewModel: vm)

        // Act
        let alert = try view.inspect().navigationStack().alert()
        let cancelButton = try alert.find(button: "Cancel")
        
        // Assert
        XCTAssertNoThrow (try cancelButton.tap())
    }
    
    func testFilterPickerUpdatesViewModelFilter() throws {
        // Arrange
        let vm = TodoListViewModel()
        let view = TodoListView(viewModel: vm)
        
        
        // Act
        let picker = try view.inspect().navigationStack().vStack().picker(0)
        try picker.select(value: TodoListViewModel.Filter.completed)
        
        // Assert
        XCTAssertEqual(vm.filter, .completed)
    }
    
    func testTappingListItemMarksItComplete() throws {
        // Arrange
        let vm = TodoListViewModel()
        vm.add(title: "Task A")
        let view = TodoListView(viewModel: vm)
        
        // Act
        let list = try view.inspect().navigationStack().vStack().list(1)
        let firstRowButton = try list.find(ViewType.HStack.self, where: { try $0.text(0).string() == "Task A" }).button(2)
        try firstRowButton.tap()
        
        // Assert
        XCTAssertTrue(vm.todos[0].isCompleted, "Tapping the list item should mark it as complete.")
    }
}
