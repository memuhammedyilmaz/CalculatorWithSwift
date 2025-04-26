//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Muhammed Yılmaz on 20.04.2025.
//

import UIKit

enum Operation : String {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "x"
    case division = "÷"
    case percent = "%"
}

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    var displayNumber: String = ""
    var secondNumber: Double = 0.0
    var operationType: Operation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = "0"
        
        let allButtons = getAllButtons(in: view)
        for button in allButtons {
            button.layer.cornerRadius = 35
            button.clipsToBounds = true
        }
    }
    
    //MARK: - @IBActions
    @IBAction func numberClicked(_ sender: UIButton) {
        if numberLabel.text == "0" {
            numberLabel.text = ""
        }
        displayNumber += sender.tag.description
        numberLabel.text = displayNumber
    }
    
    @IBAction func acButton(_ sender: Any) {
        numberLabel.text = "0"
        displayNumber = ""
        secondNumber = 0
        operationType = nil
    }
    
    @IBAction func operationClicked(_ sender: UIButton) {
        if let operation = sender.titleLabel?.text {
            if !displayNumber.isEmpty {
                
                let currentNumber = Double(displayNumber) ?? 0.0
                if let currentOperation = operationType {
                    switch currentOperation {
                    case .addition:
                        secondNumber += currentNumber
                    case .subtraction:
                        secondNumber -= currentNumber
                    case .multiplication:
                        secondNumber *= currentNumber
                    case .percent:
                        secondNumber = currentNumber / 100
                    case .division:
                        if currentNumber != 0 {
                            secondNumber /= currentNumber
                        } else {
                            alert(title: "Error", message: "Cannot divide by zero")
                            return
                        }
                    }
                } else {
                    secondNumber = currentNumber
                }
            }
            operationType = Operation(rawValue: operation)
            displayNumber = ""
            numberLabel.text = formatNumber(secondNumber)
        }
    }
    
    @IBAction func equalButton(_ sender: UIButton) {
        if !displayNumber.isEmpty {
            let currentNumber = Double(displayNumber) ?? 0.0
            guard let operation = operationType else { return }
            switch operation {
            case .addition:
                secondNumber += currentNumber
            case .subtraction:
                secondNumber -= currentNumber
            case .multiplication:
                secondNumber *= currentNumber
            case .percent:
                secondNumber *= currentNumber / 100
            case .division:
                if currentNumber != 0 {
                    secondNumber /= currentNumber
                } else {
                    alert(title: "Error", message: "Cannot divide by zero")
                    return
                }
            }
        }
        operationType = nil
        displayNumber = ""
        numberLabel.text = formatNumber(secondNumber)
    }
    
    @IBAction func chanceButton(_ sender: UIButton) {
        if let currentNumber = Double(displayNumber) {
            secondNumber = -currentNumber
            numberLabel.text = formatNumber(secondNumber)
            displayNumber = ""
        }
    }
    
    @IBAction func commaButton(_ sender: UIButton) {
        if displayNumber.contains(".") { return }
        displayNumber += "."
        numberLabel.text = displayNumber
    }
    
    //MARK: - Functions
    
    func getAllButtons(in view: UIView) -> [UIButton] {
        var buttons = [UIButton]()
        for subview in view.subviews {
            if let button = subview as? UIButton {
                buttons.append(button)
            } else {
                buttons.append(contentsOf: getAllButtons(in: subview))
            }
        }
        return buttons
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func formatNumber(_ number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(number))
        } else {
            return String(format: "%.2f", number)
        }
    }
}
