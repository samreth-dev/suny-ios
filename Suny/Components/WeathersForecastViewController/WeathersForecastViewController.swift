//
//  WeathersForecastViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import UIKit
import SafariServices

class WeathersForecastViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    private var viewModel: any WeathersForecastViewModelProtocol

    init(viewModel: any WeathersForecastViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        let nib = UINib(nibName: "WeathersForecastCollectionViewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WeathersForecastCollectionViewTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        let viewModelHeader = WeathersForecastHeaderViewModel(cityString: viewModel.cityString, tempString: viewModel.tempString, iconString: viewModel.iconString)
        let headerView = WeathersForecastHeader(viewModel: viewModelHeader)
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 250)
        
        tableView.tableHeaderView = headerView
        
        let viewModelFooter = WeathersForecastFooterViewModel(imageUrl: viewModel.attribution!.combinedMarkDarkURL) {
            let sfViewController = SFSafariViewController(url: self.viewModel.attribution!.legalPageURL)
            self.present(sfViewController, animated: true)
        }
        let footerView = WeathersForecastFooter(viewModel: viewModelFooter)
        footerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 70)
        tableView.tableFooterView = footerView
    }
}

//MARK: datasource & delegate
extension WeathersForecastViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeathersForecastCollectionViewTableViewCell", for: indexPath) as? WeathersForecastCollectionViewTableViewCell else { return UITableViewCell() }
        
        let weathers = self.viewModel.getWeathers(index: indexPath.section)
        let viewModel = WeathersForecastCellViewModel(weathers: weathers)
        cell.config(viewModel: viewModel)
        
        return cell
    }
}

extension WeathersForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
}
