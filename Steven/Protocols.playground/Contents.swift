//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

protocol test {
    var color: UIColor {get set}
}

extension test {
    func myFunc() {
        print("test")
    }
}

class testClass: test {
    var color: UIColor = UIColor.red
}

let myTest = testClass()

myTest.myFunc()

enum testEnum: test {
    var color: UIColor {
        set {
            
        }
        
        get {
            return UIColor.blue
        }
    }
}

