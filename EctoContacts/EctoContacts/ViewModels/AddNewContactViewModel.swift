//
//  AddNewContactViewModel.swift
//  EctoContacts
//
//  Created by Pavan Powani on 10/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import Foundation

protocol AddNewContactVCDelegate: AnyObject {
    func showError(with message: String)
    func dismiss()
}

class AddNewContactViewModel {
    weak var delegate: AddNewContactVCDelegate!

    init(delegate: AddNewContactVCDelegate) {
        self.delegate = delegate
    }
    func addNewContact(with params: [String: String]) {
        let url = NetworkManager.baseURL + "/contacts"

        NetworkManager.shared.post(urlString: url, parameters: params) { [weak self] (data, response, error) in
            if error != nil {
                self?.delegate.showError(with: "We could not add this contact!")
            } else {
                self?.delegate.dismiss()
            }
        }
    }
}
