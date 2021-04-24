//
//  BUICollectionReusableView.swift
//  BibliotecaCESARSchool
//
//  Created by RENATA on 18/04/21.
//

import UIKit

class BibliotecaSectionHeaderView: UICollectionReusableView {
    @IBOutlet var label: UILabel!

    let biblioteca = Biblioteca.shared
    
    var labelOk: String! {
        didSet {
            label.text = labelOk
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        label = UILabel(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width, height: 44))
        addSubview(label)
        label.textAlignment = .center
        label.text = biblioteca.livros[0].categories[0]
        backgroundColor = .systemGray6

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
