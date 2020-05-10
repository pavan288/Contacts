//
//  ViewController.swift
//  EctoContacts
//
//  Created by Pavan Powani on 09/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var contactsTableView: UITableView!
    var viewModel: ContactsListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ContactsListViewModel(delegate: self)
        setupTableView()
        fetchData()
        setupNavBar()
        showLoader()
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
        contactsTableView.alwaysBounceVertical = false
        contactsTableView.sectionIndexColor = UIColor.gray
        contactsTableView.tableFooterView = UIView()
    }

    @objc func addContact(_ sender: Any) {
        if let controller = AddNewContactViewController.getController() {
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            self.navigationController?.present(navController, animated: true)
        }
    }

    private func fetchData() {
        viewModel?.fetchContactsList()
    }

    func showLoader() {
        self.view.isUserInteractionEnabled = false
        loader.startAnimating()
        loader.isHidden = false
    }

    func hideLoader() {
        self.view.isUserInteractionEnabled = true
        loader.isHidden = true
        loader.stopAnimating()
    }
}

extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let section = viewModel?.sections[section]
        return section?.contacts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as! ContactsTableViewCell
        if let contact = viewModel?.getContact(sectionIndex: indexPath.section, contactIndex: indexPath.row) {
            cell.setup(with: contact)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.sections.map({ $0.letter.capitalized })
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.sections[section].letter.capitalized
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contact = viewModel?.getContact(sectionIndex: indexPath.section, contactIndex: indexPath.row)  else { return }
        guard let controller = ContactDetailViewController.getController(with: contact) else { return }
        self.navigationController?.pushViewController(controller, animated: true)
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
        hideLoader()
        contactsTableView.reloadData()
    }
}
