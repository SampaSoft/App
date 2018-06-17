//
//  ordemCompraVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 17/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Firebase

class ordemCompraVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ordemTbl: UITableView!
    @IBOutlet weak var titleLbl: UINavigationItem!
    
    var ordens = [Ordem]()
    var orgaoID = ""
    var orgaoNome = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordemTbl.delegate = self
        ordemTbl.dataSource = self
        
        titleLbl.title = orgaoNome
        DataService.ds.REF_ORGAO.child(orgaoID).child("OC").observe(.value, with: {(snapshot) in
            self.ordens.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
//                        print(postDict)
                        let ordem = Ordem(postKey: key, postData: postDict)
                        self.ordens.append(ordem)
                    }
                }
            }
            self.ordemTbl.reloadData()
            //            self.carregandoV.isHidden = true
            //            self.activityIV.stopAnimating()
        })
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = ordens[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? OrdemTVC {
            cell.configureCell(ordens: post, orgaoID: orgaoID)
            return cell
        } else {
            return OrdemTVC()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return array.count
        return 1
    }
    
    @IBAction func voltarBtnPressed(_ sender: UIBarButtonItem) {
                 self.dismiss(animated: true, completion: nil)
    }
}
