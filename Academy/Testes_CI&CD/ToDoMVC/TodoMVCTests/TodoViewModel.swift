//
//  TodoMVCTests.swift
//  TodoMVCTests
//
//  Created by Manoel Pedro Prado Sa Teles on 02/03/26.
//  Copyright © 2026 Ryan Ashcraft. All rights reserved.
//

import XCTest

@testable import TodoMVC

final class TodoViewModelTests: XCTestCase {
    
    private var sut: TodoViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = TodoViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_addTask() {
        // Arrange
        let newTodoTask = "Test Task"
        let initalTaskCount = sut.items.count
        
        //Act
        sut.createTodo(title: newTodoTask)
        
        //Assert
        XCTAssertEqual(sut.items.count, initalTaskCount + 1)
        XCTAssertEqual(sut.items.last?.title, newTodoTask)
    }
    
    func test_addTask_withEmptyTittle() {
        //Arrange
        let initalTaskCount = sut.items.count
        
        //Act
        sut.createTodo(title: "")
        
        //Assert
        XCTAssertEqual(sut.items.count, initalTaskCount)
        
    }
}
