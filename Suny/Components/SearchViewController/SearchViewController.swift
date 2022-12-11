//
//  SearchViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import UIKit
import MapKit
import Combine

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: SearchViewModelProtocol
    private var cancellable: Set<AnyCancellable>
    init(viewModel: SearchViewModelProtocol, cancellable: Set<AnyCancellable>) {
        self.viewModel = viewModel
        self.cancellable = cancellable
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.publisher.receive(on: DispatchQueue.main).sink { results in
            self.tableView.reloadData()
        }.store(in: &cancellable)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupViews() {
      
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func unfocusSearchBar() {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = viewModel.results[indexPath.row]
        cell.textLabel?.text = result.city + ", " + result.country
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        return cell
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //change searchCompleter depends on searchBar's text
        if !searchText.isEmpty {
            viewModel.setup()
            viewModel.completer.queryFragment = searchText
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let geocoder = CLGeocoder()
        let result = viewModel.results[indexPath.row]
        print(result)
        
        geocoder.geocodeAddressString(result.city + ", " + result.country, completionHandler: {(placemarks, error) -> Void in
           if((error) != nil){
              print("Error", error)
           }
           if let placemark = placemarks?.first {
               if let location = placemark.location {
                   
                   self.viewModel.locationCallBack(location)
               }
               
              }
            })
        self.dismiss(animated: true)
    }
}
