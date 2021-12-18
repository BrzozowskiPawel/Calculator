//
//  CalculatorManager.swift
//  Calculator
//
//  Created by Paweł Brzozowski on 18/12/2021.
//

import Foundation

class CalculatorManager {
    
    // Declaration
    var calculationArray = [Double]()
    var lastNumber = 0.0
    var lastOperation = 0.0
    var currentNumber = 0.0
    
    func calaculateValue(operation: String) -> String? {
        if operation == "operation" {
            print("CALCUALTING!")
            // If size isn't > 3 we cannot perform operation coz there is only 1 number
            if calculationArray.count > 3 {
                // Calculate
                let newValue = calculate(firstNumber: calculationArray[0], secondNumber: calculationArray[2], operation: Int(calculationArray[1]))
                calculationArray.removeAll()
                calculationArray.append(newValue)
                calculationArray.append(lastOperation)
                return String(calculationArray[0])
            }
        } else if operation == "equals" {
            
        }
        
        return nil
    }
    
    private func calculate( firstNumber: Double, secondNumber: Double, operation: Int) -> Double{
        var total = 0.0
        
        switch operation {
        case 0:
            total =  firstNumber + secondNumber
        case 1:
            total =  firstNumber - secondNumber
        case 2:
            total =  firstNumber * secondNumber
        case 3:
            total =  firstNumber / secondNumber
        default:
            print("ERROR OPERATION INDEX")
        }
        
        // Defult operation gives few decimal palces, we would like only 3 digits
        return Double(floor(1000*total)/1000)
    }
}
