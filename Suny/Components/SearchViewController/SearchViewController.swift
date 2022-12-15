//
//  SearchViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: SearchViewModelProtocol!
    
    init(viewModel: SearchViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        binding()
    }
}

//MARK: private views configurations
private extension SearchViewController {
    func setupViews() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func binding() {
        viewModel.publisher.receive(on: DispatchQueue.main).sink { [weak self] results in
            self?.tableView.reloadData()
        }.store(in: &viewModel.cancellable)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
}

//MARK: datasource & delegate
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = viewModel.getLocationString(index: indexPath.row)
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.search(index: indexPath.row)
        self.dismiss(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            viewModel.setup()
            viewModel.completer.queryFragment = searchText
        }
    }
}
