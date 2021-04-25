//
//  MasterTableViewController.swift
//  CatalogoSippetsEstudoProva
//
//  Created by RENATA on 27/03/21.
//

import UIKit

protocol SnippetSelectionDelegate: AnyObject {
    func snippetSelected(_ newSnippet: Snippet)
}

protocol TagSnippetInsertDelegate: AnyObject {
    func tagSnippetInserted(_ tagName: String)
}

class MasterTableViewController: UITableViewController {
    
    weak var delegate: SnippetSelectionDelegate?
    weak var delegat: TagSnippetInsertDelegate?
    
    var tag: Tag? {
        didSet {
            refreshUI()
        }
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        title = tag?.tagName ?? "New Snippet"
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int {
        (tag?.snippets.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        title = tag?.tagName ?? "New Snippet"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = tag?.snippets[indexPath.row].name
        
        return cell
    }
    
    
    @IBAction func addNewSnippet(_ sender: Any) {
        tag?.snippets.insert(Snippet(name:"Novo Snippet", content:""), at: 0)
        delegat?.tagSnippetInserted(tag!.tagName)
        tableView.reloadData()
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        let selectedSnippet = tag?.snippets[indexPath.row]
        delegate?.snippetSelected(selectedSnippet!)
        
        if (delegate as? DetailViewController) != nil {
            splitViewController?.show(.secondary)
        }
    }
}

extension DetailViewController: SnippetSelectionDelegate {
    func snippetSelected(_ newSnippet: Snippet) {
        snippet = newSnippet
    }
}

extension SupplementaryTableViewController: TagSnippetInsertDelegate {
    func tagSnippetInserted(_ tagName: String) {
        
        var index = 0
        tags.forEach { tag in
            if(tag.tagName == tagName) {
                tags[index].snippets.insert(Snippet(name:"Novo Snippet", content:""), at: 0)
            }
            index = index + 1
        }
    }
}
