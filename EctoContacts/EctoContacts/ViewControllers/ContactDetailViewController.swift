//
//  ContactDetailViewController.swift
//  EctoContacts
//
//  Created by Pavan Powani on 10/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var favourtieButton: UIButton!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var contact: Contact?
    var gradient = CAGradientLayer()

    static func getController(with contact: Contact) -> ContactDetailViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController {
            controller.contact = contact
            return controller
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        populateDetails()
        applyGradient()
        setupNavBar()
    }

    override func viewWillLayoutSubviews() {
        self.gradient.frame = self.headerView.bounds
    }

    func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = Themes.primaryColour
        let addContactButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editContact(_:)))
        self.navigationItem.setRightBarButton(addContactButton, animated: false)
    }

    @objc func editContact(_ sender: Any) {
        print("edit pressed")
    }

    func populateDetails() {
        contactNameLabel.text = String(format: "%@ %@", contact?.firstName.capitalized ?? "", contact?.lastName.capitalized ?? "")
        contactImageView.layer.cornerRadius = contactImageView.frame.size.height / 2
        contactImageView.layer.borderWidth = 4
        contactImageView.layer.borderColor = UIColor.white.cgColor
        updateFavouriteButton()
        emailLabel.text = contact?.email ?? ""
        mobileLabel.text = contact?.phone ?? ""
    }

    func applyGradient() {
        let startingColour = UIColor.white
        let endingColour = Themes.primaryColour.withAlphaComponent(0.5)
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [startingColour.cgColor, endingColour.cgColor]
        headerView.layer.insertSublayer(self.gradient, at: 0)
    }

    @IBAction func messageButtonTapped(_ sender: Any) {
    }
    @IBAction func callButtonTapped(_ sender: Any) {
    }
    @IBAction func emailButtonTapped(_ sender: Any) {
    }
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        contact?.favorite.toggle()
        updateFavouriteButton()
    }

    func updateFavouriteButton() {
        if contact?.favorite ?? false {
            favourtieButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal)
        } else {
            favourtieButton.setImage(UIImage(named: "favourite_button"), for: .normal)
        }
    }

}
