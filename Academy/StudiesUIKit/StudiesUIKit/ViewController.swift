//
//  ViewController.swift
//  StudiesUIKit
//
//  Created by Manoel Pedro Prado Sa Teles on 15/05/26.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var testeLabel: UILabel!
    @IBOutlet weak var quantidadeLabel: UILabel!
    
    
    var quantidade: Int = 0
    
    @IBAction func somarTapped(_ sender: UIButton) {
        quantidade += 1
        quantidadeLabel.text = "Quantidade: \(quantidade)"
        
        
    }
    
    @IBAction func irParaTerceiraView(_ sender: UIButton) {
        let swiftUIView = TerceiraView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @IBAction func irParaSegundaView(_ sender: UIButton) {
        let segunda = SegundaView()
        present( segunda , animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}

