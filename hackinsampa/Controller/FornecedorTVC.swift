//
//  FornecedorTVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 17/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit

class FornecedorTVC: UITableViewCell {

    @IBOutlet weak var fornecedorLbl: UILabel!
    @IBOutlet weak var valorLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(fornecedor: String, valor: Double) {
        fornecedorLbl.text = fornecedor
        valorLbl.text = "Valor: R$ \(String(format: "%.2f", valor))"
    }

}
