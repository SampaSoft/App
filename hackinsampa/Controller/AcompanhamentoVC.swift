//
//  AcompanhamentoVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase

class AcompanhamentoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var carregandoV: UIView!
    @IBOutlet weak var activityAIV: UIActivityIndicatorView!
    @IBOutlet weak var favoritosTbl: UITableView!
    
    var array = [[""]]
    
    var arrayOC = ["Ordem de Compra"]
    var arrayOCOrgao = ["Ordem de Compra-orgao"]
    var arrayOrgao = ["Órgão"]
    var arrayOCOrgao2 = ["orgao"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carregandoV.isHidden = false
        activityAIV.startAnimating()
        
        // Do any additional setup after loading the view.
        favoritosTbl.delegate = self
        favoritosTbl.dataSource = self
        
        let userref = DataService.ds.REF_USER_CURRENT
        userref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let ocs = value?["oc"] as? NSDictionary {
                for oc in ocs {
                    DataService.ds.REF_ORGAO.child(oc.value as! String).child("OC").observe(.value, with: {(snapshot) in
                        self.arrayOC = ["Ordem de Compra"]
                        self.arrayOCOrgao = ["Ordem de Compra-orgao"]
                        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                            for snap in snapshot {
                                if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                    for snap2 in postDict {
                                        if snap2.key == "id" {
                                            print("OC")
                                            self.arrayOC.append((snap2.value as? String)!)
                                            self.arrayOCOrgao.append(oc.value as! String)
                                        }
                                    }
                                }
                            }
                            
                        }
                        self.array = [ self.arrayOC, self.arrayOrgao ]
                        self.favoritosTbl.reloadData()
                        self.carregandoV.isHidden = true
                        self.activityAIV.stopAnimating()

                    })
                }
            }
            
            if let orgaos = value?["orgao"] as? NSDictionary {
                self.arrayOrgao = ["Órgão"]
                self.arrayOCOrgao2 = ["orgao"]
                for orgao in orgaos {
                    DataService.ds.REF_ORGAO.child(orgao.key as! String).observe(.value, with: {(snapshot) in
                        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                            for snap in snapshot {
                                
                                if snap.key == "nome" {
                                    self.arrayOrgao.append((snap.value as? String)!)
                                    self.arrayOCOrgao2.append(orgao.key as! String)
                                }
                                
                            }
                        }
                        self.array = [ self.arrayOC, self.arrayOrgao ]
                        self.favoritosTbl.reloadData()
                    })
                }
            }
            self.array = [ self.arrayOC, self.arrayOrgao ]
            self.favoritosTbl.reloadData()
        })
        array = [ arrayOC, arrayOrgao ]
        favoritosTbl.reloadData()
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "secretaria", sender: nil)
    }
    
    @IBAction func barraPressed(_ sender: UISegmentedControl) {
        self.array = [ self.arrayOC, self.arrayOrgao ]
        self.favoritosTbl.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritosTbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = array[indexPath.section][indexPath.row + 1]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return array[section][0]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "DadosOCVC") as! DadosOCVC
            controller.id  = array[indexPath.section][indexPath.row + 1]
            controller.orgaoID = arrayOCOrgao[indexPath.row + 1]
            self.present(controller, animated: true, completion: nil)
        }else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "OrgaoDadosVC") as! OrgaoDadosVC
            controller.orgao = array[indexPath.section][indexPath.row + 1]
            controller.orgaoID = arrayOCOrgao2[indexPath.row + 1]
            self.present(controller, animated: true, completion: nil)
        }
    }
}
