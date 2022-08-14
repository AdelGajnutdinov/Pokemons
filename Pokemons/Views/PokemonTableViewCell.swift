//
//  PokemonTableViewCell.swift
//  Pokemons
//
//  Created by Adel Gainutdinov on 14.08.2022.
//

import Foundation
import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    static var cellIdentifier = "Cell"

    var pokemon: Pokemon? {
        didSet {
            self.nameLabel.text = pokemon!.name
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
