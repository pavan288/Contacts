//
//  ViewController.swift
//  EctoContacts
//
//  Created by Pavan Powani on 09/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    var viewModel: ContactsListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ContactsListViewModel()
        viewModel?.delegate = self
        setupTableView()
        fetchData()
    }

    func setupTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }

    func fetchData() {
        viewModel?.fetchContactsList()
    }

}

extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension ContactsListViewController: ContactsListVCDelegate {
    func showError(with message: String) {
        let alert = UIAlertController(title: "Sorry!", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.dismiss(animated: true)
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true)
    }

    func populateContacts() {
        contactsTableView.reloadData()
    }
}
