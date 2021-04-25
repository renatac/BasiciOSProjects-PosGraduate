//
//  ViewController.swift
//  SuperSenha
//
//  Created by RENATA on 15/03/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfTotalPasswords: UITextField!
    @IBOutlet weak var tfNumberOfCharacters: UITextField!
    @IBOutlet weak var swLetters: UISwitch!
    @IBOutlet weak var swNumbers: UISwitch!
    @IBOutlet weak var swCaptitalLetters: UISwitch!
    @IBOutlet weak var swSpecialCharacters: UISwitch!
    
    @IBOutlet weak var btnGenaratePasswords: UIButton!
    
    var btnIsEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func enableOrDisableBtn(_ sender: Any){
        btnIsEnable = swLetters.isOn || swNumbers.isOn || swCaptitalLetters.isOn || swSpecialCharacters.isOn
        if(btnIsEnable) {
            btnGenaratePasswords.alpha = 1.0
            btnGenaratePasswords.isEnabled = true
        }else{
            btnGenaratePasswords.alpha = 0.3
            btnGenaratePasswords.isEnabled = false
        }
    }
    
    func a(_ field: String, _ subtitle: String) {
        let alert = UIAlertController(title: "Ajuste o campo \(field)!", message: "Preencha o campo \(field) com um número que esteja entre \(subtitle)." , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if  (tfTotalPasswords.text! as NSString).integerValue <= 0  || (tfTotalPasswords.text! as NSString).integerValue  > 99 {
            a("Quantidade de Senhas", "1 e 99")
        } else if (tfNumberOfCharacters.text! as NSString).integerValue <= 0 || (tfNumberOfCharacters.text! as NSString).integerValue > 16{
            a("Total de Caracteres", "1 e 16")
        }else {
            let passwordsViewController = segue.destination as! PasswordViewController
            
            // forma mais segura (usar if let)
            if let numberOfPasswords = Int(tfTotalPasswords.text!) {
                // se conseguir obter o valor do campo e converter para inteiro
                passwordsViewController.numberOfPasswords = numberOfPasswords
            }
            if let numberOfCharacters = Int(tfNumberOfCharacters.text!) {
                passwordsViewController.numberOfCharacters = numberOfCharacters
            }
            passwordsViewController.useNumbers = swNumbers.isOn
            passwordsViewController.useUppercaseLetters = swCaptitalLetters.isOn
            passwordsViewController.useLowercaseLetters = swLetters.isOn
            passwordsViewController.useSpecialCharacters = swSpecialCharacters.isOn
            
            // forcar encerrar o modo de edicao // remove o foco e libera teclado
            view.endEditing(true)
        }
    }
    
}

