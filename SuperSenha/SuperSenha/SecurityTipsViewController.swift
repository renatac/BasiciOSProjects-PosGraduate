//
//  SecurityTipsViewController.swift
//  SuperSenha
//
//  Created by RENATA on 16/03/21.
//

import UIKit

class SecurityTipsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        
        if let filepath = Bundle.main.path(forResource: "DicasSenha", ofType: "txt") {
            let contents = try? String(contentsOfFile: filepath)
            textView.text = contents ?? "Não foi possível carregar o arquivo"
        }
    }
    
    //Mark: - Action
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
