//
//  Fornecedor.swift
//  hackinsampa
//
//  Created by Carlos Doki on 17/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import Foundation
import Firebase

class Fornecedor {
    private var _postKey : String!
    private var _postRef: DatabaseReference!
    private var _nomeFantasia : String!
    
    var postKey: String {
        return _postKey
    }
    
    var nomeFantasia : String {
        return _nomeFantasia
    }
    
    init(nomeFantasia: String) {
        self._nomeFantasia = nomeFantasia
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let nomeFantasia = postData["nomeFantasia"] as? String {
            self._nomeFantasia = nomeFantasia
        }
        _postRef = DataService.ds.REF_ORDEM.child(_postKey)
    }
}
