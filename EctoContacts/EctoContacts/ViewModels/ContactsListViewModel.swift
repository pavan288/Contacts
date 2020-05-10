//
//  ContactsListViewModel.swift
//  EctoContacts
//
//  Created by Pavan Powani on 10/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import Foundation

protocol ContactsListVCDelegate: AnyObject {
    func showError(with message: String)
    func populateContacts()
}

class ContactsListViewModel {
    weak var delegate: ContactsListVCDelegate!
    var contacts = [Contact]() {
        didSet {
            alphabeticContactsDict = Dictionary(grouping: contacts, by: { String($0.firstName.prefix(1))})
            let keys = alphabeticContactsDict.keys.sorted()
            sections = keys.map({ Section(letter: $0, contacts: alphabeticContactsDict[$0]!)})
        }
    }
    var sections: [Section] = []
    var alphabeticContactsDict: [String: [Contact]] = [:]

    func fetchContactsList() {
        let url = NetworkManager.baseURL + "/contacts"

        NetworkManager.shared.get(urlString: url) { [weak self] (data, response, error) in
            if error != nil {
                self?.delegate.showError(with: "Could not fetch contacts!")
            } else {
                do {
                    guard let data = data else {
                        self?.delegate.showError(with: "Could not parse contacts!")
                        return
                    }
                    let contactsArray = try JSONDecoder().decode([Contact].self, from: data)
                    self?.contacts = contactsArray
                    self?.delegate.populateContacts()
                } catch {
                    self?.delegate.showError(with: "Could not parse contacts!")
                }
            }
        }
    }

    func getContact(sectionIndex: Int, contactIndex: Int) -> Contact {
        let section = sections[sectionIndex]
        let contact = section.contacts[contactIndex]
        return contact
    }
}
