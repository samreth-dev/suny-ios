//
//  WeathersForecastViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import UIKit



class WeathersForecastViewController: UIViewController {
    private var viewModel: any WeathersForecastViewModelProtocol


    init(viewModel: any WeathersForecastViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
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
        
        let viewModel = WeathersForecastHeaderViewModel(cityString: viewModel.cityString, tempString: viewModel.tempString, iconString: viewModel.iconString)
        let headerView = WeathersForecastHeader(viewModel: viewModel)
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 250)
        
        tableView.tableHeaderView = headerView
    }
}

extension WeathersForecastViewController:UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeathersForecastCollectionViewTableViewCell", for: indexPath) as! WeathersForecastCollectionViewTableViewCell
        let weathers = self.viewModel.getWeathers(index: indexPath.section)
        let viewModel = WeathersForecastCellViewModel(weathers: weathers)
        cell.config(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
               headerView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
}
