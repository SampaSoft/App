//
//  Ordem.swift
//  hackinsampa
//
//  Created by Carlos Doki on 17/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import Foundation
import Firebase

class Ordem {
    private var _postRef: DatabaseReference!
    private var _postKey : String!
    private var _id : String!
    private var _descricao : String!
    private var _justificativa : String!
    private var _dataAprovado : String!
    private var _dataCadastro : String!
    private var _protocolo : String!
    
    var postKey: String {
        return _postKey
    }
    
    var id : String {
        return _id
    }
    
    var descricao : String {
        return _descricao
    }
    
    var justificativa : String {
        return _justificativa
    }
    
    var dataAprovado : String {
        return _dataAprovado
    }
    
    var dataCadastro : String {
        return _dataCadastro
    }
    
    var protocolo : String {
        return _protocolo
    }
    
    init(id: String, descricao: String, justificativa: String, dataAprovado: String, dataCadastro: String, protocolo: String) {
        self._id = id
        self._descricao = descricao
        self._justificativa = justificativa
        self._dataAprovado = dataAprovado
        self._dataCadastro = dataCadastro
        self._protocolo = protocolo
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let id = postData["id"] as? String {
            self._id = id
        }
        
        if let descricao = postData["descricao"] as? String {
            self._descricao = descricao
        }
        
        if let justificativa = postData["justificativa"] as? String {
            self._justificativa = justificativa
        }
        
        if let dataAprovado = postData["dataAprovado"] as? String {
            self._dataAprovado = dataAprovado
        }
        
        if let dataCadastro = postData["dataCadastro"] as? String {
            self._dataCadastro = dataCadastro
        }
        
        if let protocolo = postData["protocolo"] as? String {
            self._protocolo = protocolo
        }
        _postRef = DataService.ds.REF_ORDEM.child(_postKey)
    }
}
