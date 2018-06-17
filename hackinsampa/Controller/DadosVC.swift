//
//  DadosVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class DadosVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nomeLbl: UITextField!
    @IBOutlet weak var cepLbl: UITextField!
    @IBOutlet weak var logradouroLbl: UITextField!
    @IBOutlet weak var numeroLbl: UITextField!
    @IBOutlet weak var complementoLbl: UITextField!
    @IBOutlet weak var bairroLbl: UITextField!
    @IBOutlet weak var municipioLbl: UITextField!
    @IBOutlet weak var estadoLbl: UITextField!
    @IBOutlet weak var cpfLbl: UITextField!
    @IBOutlet weak var rgLbl: UITextField!
    @IBOutlet weak var datanascimentoLbl: UITextField!
    @IBOutlet weak var sexoLbl: UITextField!
    
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.REF_USERS.child(KeychainWrapper.standard.string(forKey: KEY_UID)!).observeSingleEvent(of: .value, with: { (snapshot) in
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
                    if snap.key == "cpf" {
                        self.cpfLbl.text = snap.value as? String
                    }
                    if snap.key == "RG" {
                        self.rgLbl.text = snap.value as? String
                    }
                    if snap.key == "datanascimento" {
                        self.datanascimentoLbl.text = snap.value as? String
                    }
                    if snap.key == "sexo" {
                        self.sexoLbl.text = snap.value as? String
                    }


                }
            }
        })
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Add touch gesture for contentView
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
}
// MARK: UITextFieldDelegate
extension DadosVC: UITextFieldDelegate {
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

// MARK: Keyboard Handling
extension DadosVC {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
            })
            
            // move if keyboard hide input field
            var distanceToBottom = CGFloat(0)
            if activeField?.frame.origin.y != nil {
                distanceToBottom = self.scrollView.frame.size.height - ((activeField?.frame.origin.y)!+50) - (activeField?.frame.size.height)!
            }
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace < 0 {
                // no collapse
                return
            }
            
            // set new offset for scroll view
//            UIView.animate(withDuration: 0.3, animations: {
//                // scroll to the position above keyboard 10 points
//                if self.lastOffset.x != nil {
//                    self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 5)
//                }
//            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.keyboardHeight != nil {
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = self.lastOffset
            }
        }
        keyboardHeight = nil
    }
}
