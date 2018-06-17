//
//  DadosOCVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 17/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase

class DadosOCVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var titleLbl: UINavigationItem!
    @IBOutlet weak var descricaoLbl: UITextField!
    @IBOutlet weak var justificativaLbl: UITextField!
    @IBOutlet weak var dataAberturaLbl: UITextField!
    @IBOutlet weak var dataAprovacaoLbl: UITextField!
    @IBOutlet weak var protocoloLbl: UITextField!
    @IBOutlet weak var fornecedorTbl: UITableView!
    
    var id : String!
    var orgaoID : String!
    var arrayFornecedor = [String]()
    var arrayValor = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.title = id
        fornecedorTbl.delegate = self
        fornecedorTbl.dataSource = self
        
        DataService.ds.REF_ORGAO.child(orgaoID).child("OC").queryOrdered(byChild: "id").queryEqual(toValue: id).observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? NSDictionary {
                        self.descricaoLbl.text = postDict["descricao"] as? String
                        self.justificativaLbl.text = postDict["justificativa"] as? String
                        self.dataAberturaLbl.text = postDict["dataCadastro"] as? String
                        self.dataAprovacaoLbl.text = postDict["dataAprovado"] as? String
                        self.protocoloLbl.text = postDict["protocolo"] as? String
                        if let produto = postDict["produto"] as? NSDictionary {
                            for t in produto {
                                if let y = t.value as? NSDictionary {
                                    for z in y {
                                        if let a = z.value as? NSDictionary {
                                            for b in a {
                                                print(b)
                                                DataService.ds.REF_FORNECEDOR.child((b.key as? String)!).observeSingleEvent(of: .value, with: { (snapshot) in
                                                    if let snapshot = snapshot.children.allObjects  as? [DataSnapshot] {
                                                        for snap in snapshot {
                                                            //print(snap.key)
                                                            if snap.key as? String == "nomeFantasia" {
                                                                self.arrayFornecedor.append(snap.value as! String)
                                                            }
                                                        }
                                                    }
                                                    self.fornecedorTbl.reloadData()
                                                })
                                                if let c = b.value as? NSDictionary {
                                                    for d in c {
                                                        self.arrayValor.append(d.value as! Double)
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.fornecedorTbl.reloadData()
        })
    }
    
    @IBAction func iniciarButtonPressed(_ sender: UIButton) {
        
        //        Prezado (a):
        //
        //        A transparência pública é importante para toda a coletividade, por isso a resposta a este pedido de informação será divulgada, preservando-se dados pessoais (caso houver).
        //        Já o texto da sua pergunta só será divulgado com sua autorização.
        //
        //        Autorizo a divulgação da minha pergunta
        //        Não autorizo a divulgação da minha pergunta
        //
        //
        //        IMPORTANTE: Dados pessoais serão preservados também no texto da pergunta.
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        controller.nroLiticacao = id
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func voltarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFornecedor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? FornecedorTVC {
            cell.configureCell(fornecedor: arrayFornecedor[indexPath.row], valor: arrayValor[indexPath.row])
            return cell
        } else {
            return FornecedorTVC()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
