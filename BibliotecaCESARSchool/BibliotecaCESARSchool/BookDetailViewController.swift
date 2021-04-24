//
//  BookDetailViewController.swift
//  BibliotecaCESARSchool
//
//  Created by RENATA on 11/04/21.
//

import UIKit
import Nuke

class BookDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var pageCount: UILabel!

    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btn: UIButton!
    
    let biblioteca = Biblioteca.shared

    //var livro: Livro?
    var order : Pedido?
    
    var book: Livro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //livro = biblioteca.livros[indexPath!]
                
        if book!.quantity == 0 {
            disableBtn()
        }
        
        User.shared.pedidos.forEach { pedido in
            if pedido.livro == book {
                disableBtn()
            }
        }
        
        titleLabel.text = book!.title
        
        isbn.text = "ISBN: \(String(describing: book!.isbn!))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        
        var publishDate: String = ""
        
        if book!.publishedDate != nil {
            publishDate = dateFormatter.string(from: book!.publishedDate!)
            
            let monthsArrayAtEnglish = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            let monthsArrayAtPortuguese = ["Jan.", "Fev.", "Mar.", "Abr.", "Mai.", "Jun.", "Jul.", "Ago.", "Set.", "Out.", "Nov.", "Dez."]
            var count = 0
            while count < 12 {
                publishDate = publishDate.replacingOccurrences(of: monthsArrayAtEnglish[count], with: monthsArrayAtPortuguese[count])
                count = count + 1
            }
            publishDate = publishDate.replacingOccurrences(of: " ", with: " de ")
                
        }
        publishedDate.text = "Publicado em \(publishDate)"

        
        pageCount.text = "\(book!.pageCount) págs"
       
        var str = ""
        book!.categories.forEach { category in
            str = str + category + ", "
        }
        str = String(str.trimmingCharacters(in: .whitespaces).dropLast())
        categories.text = "Categorias: \(str)"
        shortDescription.text = book!.shortDescription
        
        if let url = book!.thumbnailUrl {
            let options = ImageLoadingOptions(
                placeholder: UIImage(systemName: "book"),
                transition: .none
            )
            Nuke.loadImage(with: url, options: options, into: image)
        }
        
        btn.layer.cornerRadius = btn.bounds.size.height/2

        quantity.text = "\(book!.quantity) exemplares disponíveis"
        
    }
    
    @IBAction func btnClick(_ sender: Any) {
        disableBtn()

        User.shared.pedidos.append(Pedido(livro: book!, dataDeEmprestimo: Date()))
        book!.quantity = book!.quantity - 1
        quantity.text = "\(book!.quantity) exemplares disponíveis"
    }
    
    private func disableBtn() {
        btn.isEnabled = false
        btn.backgroundColor = .gray
    }
}
