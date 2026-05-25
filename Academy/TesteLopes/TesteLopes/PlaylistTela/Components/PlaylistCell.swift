//
//  PlaylistCell.swift
//  TesteLopes
//
//  Created by Manoel Pedro Prado Sa Teles on 18/05/26.
//

import UIKit

class PlaylistCell: UITableViewCell {
    static let identifier: String = "PlaylistCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Playlist List"
        label.textAlignment = .center
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.text = "List of all playlists"
        label.textAlignment = .center
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "playlist")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    
    // Celula não vem de Storyboard, contrato com NSCoding
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        
        
        func setupView() {
            
            accessoryType = .disclosureIndicator
            
            let labelStack: UIStackView = {UIStackView(arrangedSubviews: [label, subtitle])}()
            labelStack.axis = .vertical
            labelStack.spacing = 10
            labelStack.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(labelStack)
            contentView.addSubview(image)
            
            NSLayoutConstraint.activate([
                image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                image.widthAnchor.constraint(equalToConstant: 100),
                image.heightAnchor.constraint(equalToConstant: 100),
                ])
        }
        
    }
}
