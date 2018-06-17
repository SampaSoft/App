//
//  OrgaoDadosVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase

class OrgaoDadosVC: UIViewController {

    @IBOutlet weak var titleLbl: UINavigationItem!
    @IBOutlet weak var nomeLbl: UITextField!
    @IBOutlet weak var cepLbl: UITextField!
    @IBOutlet weak var logradouroLbl: UITextField!
    @IBOutlet weak var numeroLbl: UITextField!
    @IBOutlet weak var complementoLbl: UITextField!
    @IBOutlet weak var bairroLbl: UITextField!
    @IBOutlet weak var municipioLbl: UITextField!
    @IBOutlet weak var estadoLbl: UITextField!
    @IBOutlet weak var cnpjLbl: UITextField!
    @IBOutlet weak var telefoneLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    
    var orgao : String!
    var orgaoID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.title = orgao
        
        DataService.ds.REF_ORGAO.child(orgaoID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == "nome" {
                        self.nomeLbl.text = snap.value as? String
                    }
                    if snap.key == "cep" {
                        self.cepLbl.text = snap.value as? String
                    }
                    if snap.key == "logradouro" {
                        self.logradouroLbl.text = snap.value as? String
                    }
                    if snap.key == "numero" {
                        self.numeroLbl.text = snap.value as? String
                    }
                    if snap.key == "complemento" {
                        self.complementoLbl.text = snap.value as? String
                    }
                    if snap.key == "bairro" {
                        self.bairroLbl.text = snap.value as? String
                    }
                    if snap.key == "municipio" {
                        self.municipioLbl.text = snap.value as? String
                    }
                    if snap.key == "estado" {
                        self.estadoLbl.text = snap.value as? String
                    }
                    if snap.key == "cnpj" {
                        self.cnpjLbl.text = snap.value as? String
                    }
                    if snap.key == "telefone" {
                        self.telefoneLbl.text = snap.value as? String
                    }
                    if snap.key == "email" {
                        self.emailLbl.text = snap.value as? String
                    }
                }
            }
        })
    }

    @IBAction func voltarButtonPressed(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    

}
