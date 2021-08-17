//
//  AppDelegate.swift
//  Examples
//
//  Created by Igor Vedeneev on 6/24/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print("result", reverseInteger(1534236469))
        print(Solution().myAtoi("with1234 words"))
        return true
    }
}

func reverseInteger(_ x: Int) -> Int {
    var result = 0
        var number = x
        while(number != 0){
            let digit = number % 10
            number/=10
            let nextStepResult = result*10
            if (nextStepResult/10 != result) {
                return 0
            }
            result = nextStepResult
            result+=digit
        }
        return result
//    guard abs(x) >= 10 else {
//        return x
//    }
//
//    var array = Array<Int>()
//
//    func _pow(_ a: Int, _ b: Int) -> Int {
//        Int(pow(Double(a),Double(b)))
//    }
//
//    var i = 0
//    let xx = abs(x)
//    let isNeg = x < 0
//    var result: Int = 0
//    let bound = _pow(2, 31)
//
//    while _pow(10, i) <= xx {
//        let digit = xx % _pow(10, i+1) / (_pow(10, i))
//        i+=1
//        if array.isEmpty && digit == 0 {
//            continue
//        }
//
//        array.append(digit)
//
//    }
//
//    for i in 0..<array.count {
//        result += array.reversed()[i]*_pow(10, i)
//    }
//
//    if result >= bound || result <= -bound {
//        return 0
//    }
//
//    return result * (isNeg ? -1 : 1)
}

class Solution {
    func myAtoi(_ s: String) -> Int {
        var normalizedString = ""
        s.forEach { char in
            switch char {
            case "0"..."9":
                normalizedString.append(char)
            case "-":
                normalizedString.append(char)
            default:
                break
            }
        }
        
        
        var result = 0
        var isNeg = false
        var i = 0
        let array = Array(normalizedString.reversed())
        for i in 0..<array.count {
            var num: Int!
            switch array[i] {
            case "0":
                num = 0
            case "1":
                num = 1
            case "2":
                num = 2
            case "3":
                num = 3
            case "4":
                num = 4
            case "5":
                num = 5
            case "6":
                num = 6
            case "7":
                num = 7
            case "8":
                num = 8
            case "9":
                num = 9
            default:
                break
            }
            
            result += num * _pow(10, i)
        }
        
        return result
    }
}


func _pow(_ a: Int, _ b: Int) -> Int {
    Int(pow(Double(a),Double(b)))
}
