//
//  ExpandableNames.swift
//  hackinsampa
//
//  Created by Carlos Doki on 15/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import Foundation

struct ExpandableNames {
    var isExpanded: Bool
    var names: [Contact]
}

struct Contact {
    let name: String
    var hasFavorited: Bool
}
