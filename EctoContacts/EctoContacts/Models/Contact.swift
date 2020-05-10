//
//  Contact.swift
//  EctoContacts
//
//  Created by Pavan Powani on 10/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import Foundation

struct Contact: Codable {
    var firstName, lastName, email, phone: String
    var favorite: Bool

    enum CodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "lastname"
        case email
        case phone
        case favorite
    }
}
