//
//  AcompanhamentoVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit

class AcompanhamentoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var favoritosTbl: UITableView!
    
    var array = [ ["Barueri", "SECRETARIA MUNICIPAL DA FAZENDA", "SECRETARIA MUNICIPAL DA PESSOA COM DEFICIENCIA", "SECRETARIA MUNICIPAL DA SAUDE", "SECRETARIA MUNICIPAL DAS PREFEITURAS REGIONAIS", "SECRETARIA MUNICIPAL DE ASSIST E DESENV SOCIAL"],
                  ["São Paulo", "CONTROLADORIA GERAL DO MUNICIPIO", "GABINETE DO PREFEITO", "PREFEITURA DO MUNICÍPIO DE SÃO PAULO", "PREFEITURA REGIONAL ARICANDUVA/FORMOSA/CARRAO", "PREFEITURA REGIONAL BUTANTA"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoritosTbl.delegate = self
        favoritosTbl.dataSource = self
    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
                    self.performSegue(withIdentifier: "secretaria", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
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
}
