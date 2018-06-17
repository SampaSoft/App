//
//  OrgaoTVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase

class OrgaoTVC: UITableViewCell {

    @IBOutlet weak var orgaoLbl: UILabel!
    @IBOutlet weak var enderecoLbl: UILabel!
    @IBOutlet weak var telefoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var visualizacaoLbl: UILabel!
    @IBOutlet weak var seguidoresLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    
    var orgaos: Orgao!
    var likesref : DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(orgaos: Orgao) {
        orgaoLbl.text = orgaos.nome
        visualizacaoLbl.text = "Visualizações: \(orgaos.visualizacoes)"
        seguidoresLbl.text = "Seguidores: \(orgaos.seguidores)"
        enderecoLbl.text = orgaos.logradouro
        telefoneLbl.text = orgaos.telefone
        emailLbl.text = orgaos.email
        self.orgaos = orgaos
        likesref = DataService.ds.REF_USER_CURRENT.child("orgao").child(orgaos.postKey)
        
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImg.image = #imageLiteral(resourceName: "fav_cinza")
            } else {
                self.likesImg.image = #imageLiteral(resourceName: "fav_yellow")
            }
            self.seguidoresLbl.text = "Seguidores: \(orgaos.seguidores)"
        })
    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImg.image = #imageLiteral(resourceName: "fav_yellow")
                self.orgaos.adjustSeguidores(addSeguidor: true)
                self.likesref.setValue(true)
            } else {
                self.likesImg.image = #imageLiteral(resourceName: "fav_cinza")
                self.orgaos.adjustSeguidores(addSeguidor: false)
                self.likesref.removeValue()
            }
            self.seguidoresLbl.text = "Seguidores: \(self.orgaos.seguidores)"
        })
    }
}
