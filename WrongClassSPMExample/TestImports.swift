//
//  TestImports.swift
//  WrongClassSPMExample
//
//  Created by Frank Schaust on 01/12/2020.
//

import Foundation
import SPMImport

class TestImports {
    var testClass: TestProtocol
    
    init(testClass: TestProtocol) {
        self.testClass = testClass
    }
    func sayHiWrapper(name: String) throws -> String {
        do {
            return try testClass.sayHi(to: name)
        } catch {
            throw TestError.TestFuncError
        }
    }
    
    func sayHi(name: String) throws -> String {
        return try testClass.sayHi(to: name)
    }
}
