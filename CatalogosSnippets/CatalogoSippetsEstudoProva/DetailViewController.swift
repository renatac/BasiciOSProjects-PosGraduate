//
//  DetailViewController.swift
//  CatalogoSippetsEstudoProva
//
//  Created by RENATA on 27/03/21.
//

import UIKit
import Sourceful

class DetailViewController: UIViewController {
    @IBOutlet weak var textView: SyntaxTextView!

    var isSwiftLexer = true

    var snippet: Snippet? {
        didSet {
            refreshUI()
        }
    }
        
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Swift") { (action) in
                self.isSwiftLexer = true
                self.refreshUI()
            },
            UIAction(title: "Python 3") { (action) in
                self.isSwiftLexer = false
                self.refreshUI()
            }
        ]
    }

    var showMenu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        title = snippet?.name ?? "New Snippet"
        textView.text = snippet?.content ?? ""
    }
    
    var sourceCodeTheme: SourceCodeTheme {
        if UIApplication.activeTraitCollection.userInterfaceStyle == .dark {
            return DarkTheme()
        } else {
            return LightTheme()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.theme = sourceCodeTheme
        textView.delegate = self

        // Attach a toolbar with common key symbols to make typing easier.
        textView.contentTextView.inputAccessoryView = UIView.editingToolbar(target: self, action: #selector(insertCharacter))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Language", image: nil, primaryAction: nil, menu: showMenu)
    }

    /// Called when the user taps a key symbol in our input accessory view.
    @objc func insertCharacter(_ sender: UIBarButtonItem) {
        guard let value = UnicodeScalar(sender.tag) else { return }
        let string = String(value)
        textView.insertText(string)
        UIDevice.current.playInputClick()
    }
}

extension DetailViewController: SyntaxTextViewDelegate {
    /// Send back our Swift lexer for this source code.
    func lexerForSource(_ source: String) -> Lexer {
        if self.isSwiftLexer {
            return SwiftLexer()
        } else {
            return Python3Lexer()
        }
    }
}

// bem bem antes


//aquiiiiii ok
