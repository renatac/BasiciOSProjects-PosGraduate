//
//  SupplementaryTableViewController.swift
//  CatalogoSippetsEstudoProva
//
//  Created by RENATA on 01/04/21.
//

import UIKit

protocol TagSelectionDelegate: AnyObject {
    func tagSelected(_ newTag: Tag)
}

class SupplementaryTableViewController: UITableViewController {
    
    weak var delegate: TagSelectionDelegate?
    
    var tags: [Tag] = [Tag(tagName: "Network", snippets:[Snippet(name: "Snippet 1", content: "let x = 10"), Snippet(name: "Snippet 4", content: "let y = true")]), Tag(tagName: "Persistência", snippets:[Snippet(name: "Snippet 2", content: "let x = 10"),
                                                                                                                                                                                                           Snippet(name: "Snippet 4", content: "let y = true")]                   )]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int {
        tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tags[indexPath.row].tagName
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        let selectedTag = tags[indexPath.row]
        
        delegate?.tagSelected(selectedTag)
        
        if (delegate as? MasterTableViewController) != nil {
            splitViewController?.show(.supplementary)
        }
    }
}

extension MasterTableViewController: TagSelectionDelegate {
    func tagSelected(_ newTag: Tag) {
        tag = newTag
    }
}
