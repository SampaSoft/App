//
//  SecretariaVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class SecretariaVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var municipioTxt: UITextField!
    @IBOutlet weak var orgaoTbl: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var array = [ ["Barueri", "SECRETARIA MUNICIPAL DE GESTAO", "SECRETARIA MUNICIPAL DE HABITACAO", "SECRETARIA MUNICIPAL DA SAUDE", "SECRETARIA MUNICIPAL DE INFRAESTRUTURA E OBRAS", "SECRETARIA MUNICIPAL DE INOVACAO E TECNOLOGIA", "SECRETARIA MUNICIPAL DE JUSTICA"],
                  ["São Paulo", "PREFEITURA REGIONAL CIDADE ADEMAR", "PREFEITURA REGIONAL CIDADE TIRADENTES", "PREFEITURA REGIONAL DE SAPOPEMBA", "PREFEITURA REGIONAL DE VILA PRUDENTE", "PREFEITURA REGIONAL ERMELINO MATARAZZO", "PREFEITURA REGIONAL FREGUESIA/BRASILANDIA", "PREFEITURA REGIONAL GUAIANASES", "PREFEITURA REGIONAL IPIRANGA", "PREFEITURA REGIONAL ITAIM PAULISTA"]]
    
    var orgaos = [Orgao]()
    
    var pickerData: [String] = [String]()
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    func someMethodIWantToCall(cell: UITableViewCell) {
        guard let indexPathTapped = orgaoTbl.indexPath(for: cell) else { return }
//          orgaoTbl.reloadRows(at: [indexPathTapped], with: .fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orgaoTbl.delegate = self
        orgaoTbl.dataSource = self
        municipioTxt.delegate = self
        
        pickerData.removeAll()
        let url = "http://servicodados.ibge.gov.br/api/v1/localidades/estados/35/municipios"
        
        Alamofire.request(url, method:.get).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSArray
                    for json in JSON {
                        let dados = json as! NSDictionary
                        self.pickerData.append(dados["nome"] as! String)
//                        print(dados["nome"] as! String)
                    }
                }
            case .failure(let error):
                print("Erro ao buscar informações")
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func voltarBtnPressed(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !autoCompleteText( in : textField, using: string, suggestions: pickerData)
    }
    
    func autoCompleteText( in textField: UITextField, using string: String, suggestions: [String]) -> Bool {
        if !string.isEmpty,
            let selectedTextRange = textField.selectedTextRange,
            selectedTextRange.end == textField.endOfDocument,
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text( in : prefixRange) {
            let prefix = text + string
            let matches = pickerData.filter {
                $0.hasPrefix(prefix)
            }
            if (matches.count > 0) {
                textField.text = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.characters.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        DataService.ds.REF_ORGAO.queryOrdered(byChild: "municipio").queryEqual(toValue: municipioTxt.text!).observe(.value, with: { (snapshot) in
            self.orgaos.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        print(postDict)
                        let post = Orgao(postKey: key, postData: postDict)
                        self.orgaos.append(post)
                    }
                }
            }
            self.orgaoTbl.reloadData()
        })
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgaos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = orgaos[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? OrgaoTVC {
            cell.configureCell(orgaos: post)
            return cell
        } else {
            return OrgaoTVC()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orgaos[indexPath.row].adjustVisualizacoes()
        let controller = storyboard?.instantiateViewController(withIdentifier: "OrgaoDadosVC") as! OrgaoDadosVC
        self.present(controller, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return array.count
        return 1
    }
}
