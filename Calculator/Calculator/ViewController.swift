//
//  ViewController.swift
//  Calculator
//
//  Created by Paweł Brzozowski on 18/12/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    var calculatorManager = CalculatorManager()
    var isValidPress = false
    var clearDisplay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func numberButtonClicked(_ sender: UIButton) {
        
        isValidPress = true
        
        if clearDisplay == true {
            resultLabel.text = ""
            clearDisplay = false
        }
        resultLabel.text! += sender.titleLabel!.text!
        
        calculatorManager.currentNumber = Double(sender.titleLabel!.text!)!
        
    }
    
    @IBAction func operationButtonOrangeClicked(_ sender: UIButton) {
        clearDisplay = true
        
        if isValidPress {
            calculatorManager.calculationArray.append(calculatorManager.currentNumber)
            calculatorManager.calculationArray.append(Double(sender.tag))
        }
        
        // Wont allow appending multiple operation buttons into array
        isValidPress = false
    }
    
    @IBAction func equalsButtonClicked(_ sender: Any) {
        print("= clciked")
    }
    
}

