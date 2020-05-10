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
    var contacts = [Contact]()

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
                    print(contactsArray)
                    self?.delegate.populateContacts()
                } catch {
                    self?.delegate.showError(with: "Could not parse contacts!")
                }
            }
        }
    }

    func getFullName(at index: Int) -> String {
        let contact = contacts[index]
        let fullName = [contact.firstName, contact.lastName].joined(separator: " ")
        return fullName
    }
}
