//
//  EmprestimosViewController.swift
//  BibliotecaCESARSchool
//
//  Created by RENATA on 15/04/21.
//

import UIKit
import Nuke

class EmprestimosViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "LivroCell"
    let preheater = ImagePreheater()
    var requests: [Pedido] = User.shared.pedidos
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nib = UINib(nibName: "LivroCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        requests = User.shared.pedidos
        collectionView.reloadData()
    }
}

extension EmprestimosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        requests.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumInteritemSpacing = 4
            layout.itemSize = CGSize(width:(self.collectionView.frame.size.width - 10),height: (self.collectionView.frame.size.height)/3)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LivroCell

        let livro = requests[indexPath.row].livro
        cell.titleLabel.text = livro.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dataDeEmprestimo = dateFormatter.string(from: requests[indexPath.row].dataDeEmprestimo)
        cell.dateLabel.text = dataDeEmprestimo

        if let url = livro.thumbnailUrl {
            let options = ImageLoadingOptions(
                placeholder: UIImage(systemName: "book"),
                transition: .none
            )

            Nuke.loadImage(with: url, options: options, into: cell.imageView)
        }
        return cell
    }
}

extension EmprestimosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let columns: CGFloat = 1
        let verticalInset: CGFloat = 16
        let spacing: CGFloat = 10
        let availableWidth = screenWidth - (verticalInset * 2) - (spacing * (columns - 1))
        let cellWidth = floor(availableWidth / columns)
        let cellHeight: CGFloat = 230
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension EmprestimosViewController: UICollectionViewDataSourcePrefetching {
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
