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
        if numberLabel.text == "0" && sender.tag == 0 {
            return
        }
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
        guard let operation = sender.titleLabel?.text else { return }
        if !displayNumber.isEmpty {
            switchControl()
        }
        operationType = Operation(rawValue: operation)
        if displayNumber.contains(".") {
            numberLabel.text = secondNumber.description
        } else {
            numberLabel.text = formatNumber(secondNumber)
        }
        displayNumber = ""
    }
    
    @IBAction func equalButton(_ sender: UIButton) {
        if !displayNumber.isEmpty {
            switchControl()
        }
        operationType = nil
        displayNumber = ""
        numberLabel.text = formatNumber(secondNumber)
    }
    
    @IBAction func chanceButton(_ sender: UIButton) {
        if displayNumber.isEmpty { return }
        guard let currentNumber = Double(displayNumber) else { return }
        let toggledNumber = -currentNumber
        displayNumber = formatNumber(toggledNumber)
        numberLabel.text = displayNumber
    }
    
    @IBAction func commaButton(_ sender: UIButton) {
        if displayNumber.contains(".") { return }
        displayNumber += "."
        numberLabel.text = formatNumber(Double(displayNumber) ?? 0.0)
    }
    
    @IBAction func percentButton(_ sender: UIButton) {
        if displayNumber.isEmpty { return }
        guard let currentNumber = Double(displayNumber) else { return }
        let percentValue = currentNumber / 100
        displayNumber = formatNumber(percentValue)
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
    
    func switchControl() {
        let currentNumber = Double(displayNumber) ?? 0.0
        if let currentOperation = operationType {
            switch currentOperation {
            case .addition:
                secondNumber += currentNumber
            case .subtraction:
                secondNumber -= currentNumber
            case .multiplication:
                secondNumber *= currentNumber
            case .division:
                if currentNumber != 0 {
                    secondNumber /= currentNumber
                } else {
                    DispatchQueue.main.async {
                        self.numberLabel.text = "Error"
                        self.alert(title: "Error", message: "Cannot divide by zero")
                    }
                    displayNumber = ""
                    return
                }
            }
        } else {
            secondNumber = currentNumber
        }
        DispatchQueue.main.async {
            self.numberLabel.text = self.formatNumber(self.secondNumber)
        }
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
