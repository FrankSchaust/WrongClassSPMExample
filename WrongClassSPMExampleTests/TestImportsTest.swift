//
//  TestImportsTest.swift
//  WrongClassSPMExampleTests
//
//  Created by Frank Schaust on 01/12/2020.
//

import Foundation
import XCTest
@testable import WrongClassSPMExample
import SPMImport
@testable import Mocks
import Cuckoo

class TestImportsTest: XCTestCase {
    func test_shouldReturnGreeting() {
        let name = "Frank"
        let expectedGreeting = "Hey \(name)! How are you?"
        let sut = TestImports(testClass: TestClass())
        XCTAssertEqual(try? sut.sayHiWrapper(name: name), expectedGreeting)
    }
    
    func test_doesNotWorkWithErrorClassFromSPMModule() {
        let name = ""
        let sut = TestImports(testClass: TestClass())
        do {
            try sut.sayHiWrapper(name: name)
        } catch {
            guard let err = error as? TestError else {
                XCTAssert(false)
                return
            }
            XCTAssert(err == TestError.TestFuncError)
        }
    }
    
    func test_doesWorkWithErrorClassInitInTestsTarget() {
        let name = ""
        let expectedError = TestError.TestFuncError
        let mockedClass = MockTestProtocol()
        stub(mockedClass) {
            when($0).sayHi(to: any()).then { _ in
                throw expectedError
            }
        }
        let sut = TestImports(testClass: mockedClass)
        do {
            _ = try sut.sayHi(name: name)
        } catch {
            guard let err = error as? TestError else {
                XCTAssert(false)
                return
            }
            XCTAssert(err == expectedError)
        }
    }
    
    func test_doesWorkWithErrorInitInSPMPackage() {
        let name = ""
        let sut = TestImports(testClass: TestClass())
        let expectedError = TestError.TestFuncError
        do {
            _ = try sut.sayHi(name: name)
        } catch {
            guard let err = error as? TestError else {
                XCTAssert(false)
                return
            }
            XCTAssert(err == expectedError)
        }
    }
}
