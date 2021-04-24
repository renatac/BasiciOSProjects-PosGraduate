//
//  BibliotecaViewController.swift
//  BibliotecaCESARSchool
//
//  Created by Ian Manor on 26/03/21.
//
import UIKit
import Nuke

class BibliotecaViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let reuseIdentifier = "LivroCell"
    let biblioteca = Biblioteca.shared
    
    let preheater = ImagePreheater()
    
    var sectionIndexPath: Int?
    var rowIndexPath: Int?
    
    var books: [Livro] = []
    var permanentBooks: [Livro] = []
    var categories: [String] = []
    var sections: [Section] = []
    
    //Armazenará os Livros que pesquisados
    var filteredBooks: [Livro] = []
    var filteredBooksCategories: [String] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //Propriedade computada para determinar se estou filtrando os resultados ou não
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Com este protocolo, UISearchResultsUpdating informará sua classe de quaisquer alterações de texto dentro do UISearchBar.
        searchController.searchResultsUpdater = self
        //Isso é útil se você estiver usando outro controlador de visualização para seu searchResultsController
        searchController.obscuresBackgroundDuringPresentation = false
        //Aqui, você define o marcador de posição para algo que seja específico para este aplicativo.
        searchController.searchBar.placeholder = "Buscar Livros"
        //Novo no iOS 11, você adiciona a searchBar ao navigationItem. Isso é necessário porque o Interface Builder ainda não é compatível com UISearchController
        navigationItem.searchController = searchController
        //Garante que a barra de pesquisa não permaneça na tela se o usuário navegar para outro controlador de visualização enquanto o UISearchController estiver ativo.
        definesPresentationContext = true
        
        collectionView.register(BibliotecaSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeaderReuseIdentifier")
        
        let nib = UINib(nibName: "LivroCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        collectionView.allowsMultipleSelection = true
        setSections()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "details") {
            let vc = segue.destination as! BookDetailViewController
            
            if isFiltering {
                vc.book = filteredBooks[rowIndexPath!]
            } else {
                vc.book = sections[sectionIndexPath!].sectionBooks[rowIndexPath!]
            }
        }
    }
    
    private func setSections() {
        for book in biblioteca.livros {
            categories = categories + book.categories
        }
        let categoriesWithoutRepetitions = Set<String>(categories)
        
        categories = categoriesWithoutRepetitions.sorted()
        categories.remove(at: 0)
       
        for category in categories {
            books = biblioteca.livros.filter { (book: Livro) -> Bool in
                return book.categories.contains(category)
            }
            sections.append(Section(sectionBooks: books, categ: category))
            sections = sections.sorted()
            books = []
        }
    
        books = biblioteca.livros.filter { (book: Livro) -> Bool in
            return book.categories.isEmpty
        }
        print(books.count)
        sections.append(Section(sectionBooks: books, categ: "Outros"))
        sections = sections.sorted()
        books = []
        
        collectionView.reloadData()
    }
       
    func filterContentForSearchText(_ searchText: String,
                                    title: String? = nil) {
        filteredBooks = []
        filteredBooksCategories = []
        filteredBooks = biblioteca.livros.filter { (book: Livro) -> Bool in
            return book.title.localizedStandardContains(searchText)
        }
        
        if isFiltering{
        for book in filteredBooks {
            let categ = book.categories.isEmpty ? ["Outros"] : book.categories
            filteredBooksCategories = filteredBooksCategories + categ
        }
        let categoriesWithoutRepetitions = Set<String>(filteredBooksCategories)

        filteredBooksCategories = categoriesWithoutRepetitions.sorted()
        }
        collectionView.reloadData()
    }
}

extension BibliotecaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredBooks.count
        }
        return sections[section].sectionBooks.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isFiltering {
            return filteredBooksCategories.count
        }
        return sections.count
    }
    
    //filtra os livros que na lista de categorias tem a categoria da seção
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LivroCell
       
        let livro: Livro
        if isFiltering {
            livro = filteredBooks[indexPath.row]
          } else {
            livro = sections[indexPath.section].sectionBooks[indexPath.row]
          }

        cell.titleLabel.text = livro.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if livro.publishedDate != nil {
            let publishDate = dateFormatter.string(from: livro.publishedDate!)
            cell.dateLabel.text = publishDate
        }
        
        if let url = livro.thumbnailUrl {
            let options = ImageLoadingOptions(
                placeholder: UIImage(systemName: "book"),
                transition: .none
            )
            
            Nuke.loadImage(with: url, options: options, into: cell.imageView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeaderReuseIdentifier", for: indexPath) as! BibliotecaSectionHeaderView
        
        if isFiltering {
            headerView.label.text = filteredBooksCategories[indexPath.section]
        } else {
            headerView.label.text =  sections[indexPath.section].categ
        }
        return headerView
    }
}

extension BibliotecaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let columns: CGFloat = 3
        let verticalInset: CGFloat = 16
        let spacing: CGFloat = 10
        let availableWidth = screenWidth - (verticalInset * 2) - (spacing * (columns - 1))
        let cellWidth = floor(availableWidth / columns)
        let cellHeight: CGFloat = 230
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension BibliotecaViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { indexPath in
            Biblioteca.shared.livros[indexPath.row].thumbnailUrl
        }
        preheater.startPreheating(with: urls)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { indexPath in
            Biblioteca.shared.livros[indexPath.row].thumbnailUrl
        }
        preheater.stopPreheating(with: urls)
    }
}

extension BibliotecaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sectionIndexPath = indexPath.section
        rowIndexPath = indexPath.row
        self.performSegue(withIdentifier: "details", sender: self)
    }
}

//Este protocolo define métodos para atualizar os resultados da pesquisa com base nas informações que o usuário insere na barra de pesquisa.
extension BibliotecaViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
