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
    
    // Reset variables to start values
    func clear() {
        calculationArray = []
        lastNumber = 0.0
        lastOperation = 0.0
        currentNumber = 0.0
    }
    
    func calaculateValue(operation: String) -> Double? {
        if operation == "operation" {
            print("CALCUALTING!")
            // If size isn't > 3 we cannot perform operation coz there is only 1 number
            if calculationArray.count > 3 {
                // Calculate
                let newValue = calculate(firstNumber: calculationArray[0], secondNumber: calculationArray[2], operation: Int(calculationArray[1]))
                calculationArray.removeAll()
                calculationArray.append(newValue)
                calculationArray.append(lastOperation)
//                return String(calculationArray[0])
                return calculationArray[0]
            }
        } else if operation == "equals" {
            if calculationArray.count >= 1 {
                // Calculate
                let newValue = calculate(firstNumber: calculationArray[0], secondNumber: lastNumber, operation: Int(lastOperation))
                calculationArray.removeAll()
                calculationArray.append(newValue)
                // Last operation wont be appended becsue user click on the equals button
//                calculationArray.append(lastOperation)
//                return String(calculationArray[0])
                return calculationArray[0]
            }
        }
        
        return nil
    }
    
    private func calculate( firstNumber: Double, secondNumber: Double, operation: Int) -> Double{
        var total = 0.0
        if let operations = Enumerations.Operations(rawValue: operation) {
        switch operations {
            case .add:
                total =  firstNumber + secondNumber
            case .subtract:
                total =  firstNumber - secondNumber
            case .multiplay:
                total =  firstNumber * secondNumber
            case .divide:
                total =  firstNumber / secondNumber
            default:
                print("ERROR OPERATION INDEX")
            }
        }
        // Defult operation gives few decimal palces, we would like only 3 digits
        return Double(floor(1000*total)/1000)
    }
}
