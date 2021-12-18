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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func numberButtonClicked(_ sender: UIButton) {
        
        resultLabel.text! += sender.currentTitle!
        calculatorManager.currentNumber = Double(resultLabel.text!)!
        
    }
    
    @IBAction func operationButtonOrangeClicked(_ sender: Any) {
    }
    
    @IBAction func equalsButtonClicked(_ sender: Any) {
    }
    
}

