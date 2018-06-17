//
//  OrdemTVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 17/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase

class OrdemTVC: UITableViewCell {
    
    @IBOutlet weak var ocLbl: UILabel!
    @IBOutlet weak var descricaoLbl: UILabel!
    @IBOutlet weak var justificativaLbl: UILabel!
    @IBOutlet weak var cadastroLbl: UILabel!
    @IBOutlet weak var aprovadoLbl: UILabel!
    @IBOutlet weak var fornecedoresLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    
    var ordens: Ordem!
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
    
    func configureCell(ordens: Ordem, orgaoID: String) {
        
        DataService.ds.REF_ORGAO.child(orgaoID).child("OC").child(ordens.postKey).observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        print("postDict.values \(postDict.values)")
                        var i = 0
                        for snap2 in postDict {
                            if let postDict2 = snap2.value as? Dictionary<String, AnyObject> {
                                for snap3 in postDict2 {
                                    if let postDict3 = snap3.value as? Dictionary<String, AnyObject> {
                                        for snap4 in postDict3 {
                                            //let key = postDict3.key
//                                            print("snap4 \(snap4)")
                                            i = i + 1
                                        }
                                    }
                                }
                            }
                        }
                        self.ocLbl.text = "OC: \(ordens.id)"
                        self.descricaoLbl.text = ordens.descricao
                        self.justificativaLbl.text = ordens.justificativa
                        self.cadastroLbl.text = "Data cadastro: \(ordens.dataCadastro)"
                        self.aprovadoLbl.text = "Data Aprovado: \(ordens.dataAprovado)"
                        self.fornecedoresLbl.text = "Fornecedores: \(i)"
                        self.likesref = DataService.ds.REF_USER_CURRENT.child("oc").child(ordens.postKey)
                        self.likesref.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let _ = snapshot.value as? NSNull {
                                self.likesImg.image = #imageLiteral(resourceName: "fav_cinza")
                            } else {
                                self.likesImg.image = #imageLiteral(resourceName: "fav_yellow")
                            }
                        })
                    }
                }
            }
            
            //            self.carregandoV.isHidden = true
            //            self.activityIV.stopAnimating()
        })
        

    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImg.image = #imageLiteral(resourceName: "fav_yellow")
                self.likesref.setValue(true)
            } else {
                self.likesImg.image = #imageLiteral(resourceName: "fav_cinza")
                
                self.likesref.removeValue()
            }
        })
    }
}
