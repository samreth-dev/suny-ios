//
//  WeathersForecastCollectionViewTableViewCell.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import UIKit

class WeathersForecastCollectionViewTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    private var viewModel: WeathersForecastCellViewModelProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(viewModel: WeathersForecastCellViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    func setupViews() {
        let nib = UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        collectionView.dataSource = self
        
        flowLayout.itemSize = CGSize(width: 130, height: 50)
    }
    
}

extension WeathersForecastCollectionViewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        cell.temperLabel.text = viewModel.weathers[indexPath.row].getTemp()
        cell.timeLabel.text = viewModel.weathers[indexPath.row].getTime()
        cell.imageView.image = UIImage(systemName: viewModel.weathers[indexPath.row].getIcon())
        return cell
    }
}
