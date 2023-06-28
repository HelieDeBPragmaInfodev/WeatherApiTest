//
//  CustomTableViewCell.swift
//  WeatherApiTest
//
//  Created by Hélie de Bernis on 28/06/2023.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftImageView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(tempLabel)
        
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        leftImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        cityNameLabel.leftAnchor.constraint(equalTo: leftImageView.rightAnchor, constant: 10).isActive = true
        
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        tempLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: tempLabel.leftAnchor, constant: -10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
