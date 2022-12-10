//
//  WeatherCollectionViewCell.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    private var viewModel: WeatherCollectionViewCellViewModelProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(viewModel: WeatherCollectionViewCellViewModelProtocol) {
        self.viewModel = viewModel
        self.imageView.image = UIImage(systemName: viewModel.imageString)
        self.temperLabel.text = viewModel.temperString
        self.timeLabel.text = viewModel.timeString
    }
}
