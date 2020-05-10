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
        setupNavBar()
    }

    func setupNavBar() {
        self.navigationItem.title = "Contacts"
        self.navigationController?.navigationBar.tintColor = Themes.primaryColour
        let addContactButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addContact(_:)))
        self.navigationItem.setRightBarButton(addContactButton, animated: false)
    }

    private func setupTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.register(UINib(nibName: "ContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactsTableViewCell")
        contactsTableView.estimatedRowHeight = 64
        contactsTableView.rowHeight = UITableView.automaticDimension
        contactsTableView.tableFooterView = UIView()
    }

    @objc func addContact(_ sender: Any) {
        print("add pressed")
    }

    private func fetchData() {
        viewModel?.fetchContactsList()
    }
}

extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.contacts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as! ContactsTableViewCell
        cell.contactName.text = viewModel?.getFullName(at: indexPath.row)
        return cell
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
