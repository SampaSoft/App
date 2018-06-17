//
//  orgao.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import Foundation
import Firebase

class Orgao {
    private var _postKey : String!
    private var _cnpj : String!
    private var _nome : String!
    private var _logradouro : String!
    private var _complemento : String!
    private var _numero : String!
    private var _municipio : String!
    private var _email : String!
    private var _telefone : String!
    private var _visualizacoes : Int!
    private var _seguidores : Int!
    private var _postRef: DatabaseReference!
    
    var postKey: String {
        return _postKey
    }
    
    var cnpj : String {
        return _cnpj
    }
    
    var nome : String {
        return _nome
    }
    
    var logradouro : String {
        return _logradouro
    }
    
    var complemento : String {
        return _complemento
    }
    
    var numero : String {
        return _numero
    }
    
    var municipio : String {
        return _municipio
    }
    
    var email : String {
        return _email
    }
    
    var telefone : String {
        return _telefone
    }
    
    var visualizacoes : Int {
        return _visualizacoes
    }
    
    var seguidores : Int {
        return _seguidores
    }
    
    init(cnpj: String, nome: String, logradouro: String, complemento: String, numero : String, municipio: String, email : String, telefone: String, visualizacoes : Int, seguidores: Int) {
        self._cnpj = cnpj
        self._nome = nome
        self._logradouro = logradouro
        self._complemento = complemento
        self._numero = numero
        self._municipio = municipio
        self._email = email
        self._telefone = telefone
        self._visualizacoes = visualizacoes
        self._seguidores = seguidores
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
     
        self._postKey = postKey
        
        if let cnpj = postData["cnpj"] as? String {
            self._cnpj = cnpj
        }

        if let nome = postData["nome"] as? String {
            self._nome = nome
        }
   
        if let logradouro = postData["logradouro"] as? String {
            self._logradouro = logradouro
        }
        
        if let complemento = postData["complemento"] as? String {
            self._complemento = complemento
        }

        if let numero = postData["numero"] as? String {
            self._numero = numero
        }

        if let municipio = postData["municipio"] as? String {
            self._municipio = municipio
        }

        if let email = postData["email"] as? String {
            self._email = email
        }
        
        if let telefone = postData["telefone"] as? String {
            self._telefone = telefone
        }
        
        if let visualizacoes = postData["visualizacoes"] as? Int {
            self._visualizacoes = visualizacoes
        }
        
        if let seguidores = postData["seguidores"] as? Int {
            self._seguidores = seguidores
        }
        
        _postRef = DataService.ds.REF_ORGAO.child(_postKey)
    }
    
    func adjustVisualizacoes() {
        _visualizacoes = _visualizacoes + 1
        _postRef.child("visualizacoes").setValue(_visualizacoes)
    }

    func adjustSeguidores(addSeguidor: Bool) {
        if addSeguidor  {
            _seguidores = _seguidores + 1
        } else {
            if _seguidores > 0 {
                _seguidores = _seguidores - 1
            }
        }
        _postRef.child("seguidores").setValue(_seguidores)
    }
}
