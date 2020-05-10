//
//  ContactsTableViewCell.swift
//  EctoContacts
//
//  Created by Pavan Powani on 10/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var favourtieButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favourtieButton.layer.cornerRadius = favourtieButton.frame.size.height / 2
    }

    func setup(with contact: Contact) {
        self.contactName.text = String(format: "%@ %@", contact.firstName, contact.lastName)
        favourtieButton.isHidden = !contact.favorite
    }
}
