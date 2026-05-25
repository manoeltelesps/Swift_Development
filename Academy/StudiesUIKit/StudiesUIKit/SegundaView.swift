//
//  SegundaView.swift
//  StudiesUIKit
//
//  Created by Manoel Pedro Prado Sa Teles on 15/05/26.
//

import UIKit

class SegundaView: UIViewController {
    
    let minhaLabel: UILabel = {
        let label = UILabel()
        label.text = "Segunda View"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let meuBotao: UIButton = {
        let button = UIButton()
        button.setTitle("Clique aqui", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
        
    }
    
    private func setupSubviews() {
        view.addSubview(minhaLabel)
        view.addSubview(meuBotao)
        
        meuBotao.addTarget(self, action: #selector(botaoTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            minhaLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minhaLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            meuBotao.topAnchor.constraint(equalTo: minhaLabel.bottomAnchor, constant: 20),
            meuBotao.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            meuBotao.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func botaoTapped() {
        print("Botão clicado!")
    }
}
